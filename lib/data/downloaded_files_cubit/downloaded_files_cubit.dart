import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/dio.dart';
import 'package:zeusfile/data/download/download_rest.dart';
import 'package:zeusfile/data/hive/hive_repository.dart';
import 'package:zeusfile/data/hive/hive_types.dart';
import 'package:zeusfile/data/statuses_cubit/network_status_cubit.dart';
import 'package:zeusfile/presentation/widgets/popup_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

part 'downloaded_files_cubit.g.dart';

enum DownloadingStatus {
  initial,
  donwloading,
  downloaded,
  failed,
}

@CopyWith()
@immutable
class DownloadingFile extends Equatable {
  // Initial downloaded file
  final DownloadedFile currentDownloadedFile;

  // File size
  final int progress;

  // File completion status
  final DownloadingStatus status;

  // Dio cancel token
  final String? taskId;

  double get progressPercent => progress / currentDownloadedFile.size;

  const DownloadingFile({
    required this.currentDownloadedFile,
    required this.taskId,
    this.progress = 0,
    this.status = DownloadingStatus.initial,
  });

  @override
  List<Object?> get props => [currentDownloadedFile, progress, status, taskId];
}

@CopyWith()
class DownloadedFilesCubitState extends Equatable {
  final Map<String, DownloadedFile> downloadedFiles;

  final DownloadingFile? currentDownloadingFile;

  const DownloadedFilesCubitState(
      {required this.downloadedFiles, this.currentDownloadingFile});

  DownloadedFilesCubitState.empty()
      : downloadedFiles = {},
        currentDownloadingFile = null;

  List<DownloadedFile> get downloadedFileList => downloadedFiles.values.toList()
    ..sort(
      (a, b) => b.dateTime.compareTo(a.dateTime),
    );

  List<DownloadedFile> downloadedFileListSearchFiles(
          {required String fileName}) =>
      downloadedFileList
          .where((file) =>
              fileName.trim().isEmpty ||
              file.fileName
                  .toLowerCase()
                  .contains(fileName.trim().toLowerCase()))
          .toList();

  DownloadingStatus get currentDownloadingStatus =>
      currentDownloadingFile?.status ?? DownloadingStatus.initial;

  bool fileExists({required String url}) =>
      downloadedFiles.values.any((element) =>
          element.url == url &&
          element.fileStatus == DownloadedFileStatus.fileFullyDownloaded);

  @override
  List<Object?> get props => [downloadedFiles, currentDownloadingFile];
}

class DownloadedFilesCubit extends Cubit<DownloadedFilesCubitState> {
  final HiveRepository hiveRepository;
  final ExtendedDownloadRest downloadRest;
  final NetworkStatusCubit networkStatusCubit;

  static const regularExpression =
      r'https?:\/\/(?:www\.)?(?<domain>[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b)*\/(?<fileCode>[\d\w\.-]*?)\/(?<fileName>[\d\w\.-]*)';

  final regularExpParser = RegExp(regularExpression);

  final _port = ReceivePort();

  DownloadedFilesCubit(
      {required this.hiveRepository,
      required this.downloadRest,
      required this.networkStatusCubit})
      : super(DownloadedFilesCubitState.empty()) {
    final isolateRegistered = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');

    FlutterDownloader.registerCallback(downloadCallback, step: 1);

    _port.listen((message) {
      final String id = message[0];
      final int status = message[1];
      final int progress = message[2];

      changeDownloadFileProgressByPercent(progressPercent: progress);

      if (progress == 100) {
        changeDownloadFileSuccess();
        return;
      }
    });

    cleanNotExistsFiles().then((result) => loadAllDownloadedFiles());

    hiveRepository.hiveNotesBoxStream.listen((BoxEvent boxEvent) {
      if (boxEvent.deleted) {
        emit(state.copyWith(
            downloadedFiles: state.downloadedFiles..remove(boxEvent.key)));
      } else {
        emit(state.copyWith(
            downloadedFiles: state.downloadedFiles
              ..putIfAbsent(boxEvent.key, () => boxEvent.value)));
      }
    });

    Timer.periodic(const Duration(seconds: 3), (timer) async {
      final tasksList = await FlutterDownloader.loadTasks();

      for (var task in tasksList ?? <DownloadTask>[]) {
        if (state.currentDownloadingFile?.taskId != task.taskId) continue;

        if (task.status == DownloadTaskStatus.complete) {
          changeDownloadFileSuccess();
          return;
        }

        if (task.status == DownloadTaskStatus.running) {
          changeDownloadFileProgressByPercent(progressPercent: task.progress);
          return;
        }

        if (task.status == DownloadTaskStatus.canceled) {
          changeDownloadFileFailed();
          return;
        }

        if (task.status == DownloadTaskStatus.failed) {
          changeDownloadFileFailed();
          return;
        }
      }
    });
  }

  void checkBackgroundTasks() {}

  Future<void> cleanNotExistsFiles() async {
    final notExistsFiles = hiveRepository.hiveDownloadedFilesBox.values.where(
        (element) => element.fileStatus == DownloadedFileStatus.fileNotExists);
    for (var element in notExistsFiles) {
      await hiveRepository.hiveDownloadedFilesBox.delete(element.key);
    }
  }

  void loadAllDownloadedFiles() =>
      emit(DownloadedFilesCubitState(downloadedFiles: {
        for (var v in hiveRepository.hiveDownloadedFilesBox.values.where(
            (element) =>
                element.fileStatus == DownloadedFileStatus.fileExists ||
                element.fileStatus == DownloadedFileStatus.fileFullyDownloaded))
          v.key: v
      }));

  String? getFileCode(String url) {
    if (!regularExpParser.hasMatch(url)) return null;

    return regularExpParser.firstMatch(url)!.namedGroup('fileCode');
  }

  static Future<bool> requestPermission() async {
    final externalStoragePermission = await Permission.storage.status;
    if (externalStoragePermission.isGranted ||
        externalStoragePermission.isLimited) return true;

    if (externalStoragePermission.isDenied) {
      final permissionRequestResult = await Permission.storage.request();

      //     .then((status) =>
      //         status.isGranted || externalStoragePermission.isLimited)
      //     .catchError((error) {
      //   print('permission error:\n$error');
      //   return false;
      // });
      return permissionRequestResult.isGranted ||
          permissionRequestResult.isLimited;
    }

    if (externalStoragePermission.isPermanentlyDenied ||
        externalStoragePermission.isRestricted) {
      openAppSettings();
      return false;
    }
    return false;
  }

  static Future<String?> getDownloadsDir() async {
    if (Platform.isIOS) return (await getApplicationDocumentsDirectory()).path;

    if (Platform.isAndroid) {
      return (await getExternalStorageDirectory())!.path;
    }

    // TODO remove
    if (Platform.isAndroid) {
      const downloadsPath = '/storage/emulated/0/Download';
      if (!(await Directory(downloadsPath).exists())) {
        Directory(downloadsPath).createSync();
      }
      return downloadsPath;
    }

    return null;
  }

  Future<String?> getLocalDirectory() async {
    final downloadsPath = await getDownloadsDir();
    if (downloadsPath == null) return null;

    final path = '$downloadsPath${Platform.pathSeparator}novafiles';
    if (!(await Directory(path).exists())) Directory(path).createSync();

    return '$path${Platform.pathSeparator}';
  }

  Future<String?> getLocalPath({required String fileName}) async {
    return '${await getLocalDirectory()}${Platform.pathSeparator}$fileName';
  }

  Future<String?> getDownloadUrl({
    required ServiceType serviceType,
    required String url,
    required String session,
  }) async {
    final fileCode = getFileCode(url);

    if (fileCode == null) return '';

    final fileResult =
        await downloadRest.by(serviceType).downloadServer(session, fileCode);
    final downloadResult = await downloadRest
        .by(serviceType)
        .downloadLink(session, fileCode, fileResult.downloadId ?? '');
    return downloadResult.link;
  }

  Future<FileType> getDownloadUrlContentType(
      {required String downloadUrl}) async {
    final dio = dioInstance();
    final result = await dio.head(downloadUrl);

    final contentType = result.headers.map.containsKey('content-type')
        ? result.headers.map['content-type']?.first
        : null;

    return FileType.file.getFileType(contentType);
  }

  Future<bool> addDownloadFile({
    required ServiceType serviceType,
    required String url,
    required String session,
  }) async {
    final fileCode = getFileCode(url);

    if (fileCode == null) return false;

    if (state.currentDownloadingStatus == DownloadingStatus.donwloading) {
      await cancelDownload();
    }

    networkStatusCubit.loading();
    try {
      final fileResult =
          await downloadRest.by(serviceType).downloadServer(session, fileCode);
      final downloadResult = await downloadRest
          .by(serviceType)
          .downloadLink(session, fileCode, fileResult.downloadId ?? '');

      final localDirectory = await getLocalDirectory() ?? '';
      final localPath =
          await getLocalPath(fileName: fileResult.fileName ?? 'temp.file');

      if (localPath == null) {
        FToast().removeQueuedCustomToasts();
        FToast().showToast(
            gravity: ToastGravity.TOP,
            toastDuration: const Duration(seconds: 3),
            child: PopUpItem(
              text:
                  'A file upload error occurred due to a permissions error. Please check app settings.',
              onTap: () {
                FToast().removeQueuedCustomToasts();
              },
            ));
        return false;
      }

      final DownloadedFile currentDownloadedFile = DownloadedFile(
          url: url,
          downloadUrl: downloadResult.link ?? '',
          fileCode: fileCode,
          fileName: fileResult.fileName ?? '',
          serviceType: serviceType,
          size: int.tryParse(fileResult.fileSize ?? '1') ?? 1,
          localPath: localPath);

      final taskId = await FlutterDownloader.enqueue(
          url: currentDownloadedFile.downloadUrl,
          // headers: {}, // optional: header send with url (auth token etc)
          savedDir: localDirectory,
          fileName: currentDownloadedFile.fileName,
          showNotification: true,
          openFileFromNotification: false,
          allowCellular: true);

      final currentDownloadingFile = DownloadingFile(
        currentDownloadedFile: currentDownloadedFile,
        taskId: taskId,
        status: DownloadingStatus.donwloading,
      );

      emit(state.copyWith(currentDownloadingFile: currentDownloadingFile));

      // final dio = dioInstance();

      // dio.download(
      //   currentDownloadingFile.currentDownloadedFile.downloadUrl,
      //   currentDownloadingFile.currentDownloadedFile.localPath,
      //   cancelToken: currentDownloadingFile.cancelToken,
      //   deleteOnError: true,
      //   onReceiveProgress: (count, total) {
      //     changeDownloadFileProgress(progress: count);
      //   },
      // ).then((downloadResponse) {
      //   if (downloadResponse.statusCode == 200) {
      //     return changeDownloadFileSuccess();
      //   }
      //   return changeDownloadFileFailed();
      // }).catchError((error) {
      //   return changeDownloadFileFailed();
      // });

      return true;
    } catch (error) {
      return false;
    } finally {
      networkStatusCubit.success();
    }
  }

  void changeDownloadFileSuccess() {
    if (state.currentDownloadingFile == null) return;
    final currentDownloadingFile = state.currentDownloadingFile!
        .copyWith(status: DownloadingStatus.downloaded);

    hiveRepository.hiveDownloadedFilesBox.put(
        state.currentDownloadingFile!.currentDownloadedFile.key,
        state.currentDownloadingFile!.currentDownloadedFile);

    emit(state.copyWith(currentDownloadingFile: currentDownloadingFile));
  }

  void changeDownloadFileFailed() {
    if (state.currentDownloadingFile == null) return;
    final currentDownloadingFile = state.currentDownloadingFile!
        .copyWith(status: DownloadingStatus.failed);
    emit(state.copyWith(currentDownloadingFile: currentDownloadingFile));

    currentDownloadingFile.currentDownloadedFile.localFile
        .delete()
        .then((value) => hiveRepository.hiveDownloadedFilesBox
            .delete(currentDownloadingFile.currentDownloadedFile.key))
        .catchError((error) {
      // TODO show error
    });
  }

  void changeDownloadFileProgressByPercent({required int progressPercent}) {
    if (state.currentDownloadingFile == null ||
        state.currentDownloadingStatus != DownloadingStatus.donwloading) return;
    final currentDownloadingFile = state.currentDownloadingFile!.copyWith(
        progress: state.currentDownloadingFile!.currentDownloadedFile.size *
            progressPercent ~/
            100,
        status: DownloadingStatus.donwloading);
    emit(state.copyWith(currentDownloadingFile: currentDownloadingFile));
  }

  void changeDownloadFileProgress({required int progress}) {
    if (state.currentDownloadingFile == null ||
        state.currentDownloadingStatus != DownloadingStatus.donwloading ||
        progress - state.currentDownloadingFile!.progress < 1000) return;
    final currentDownloadingFile = state.currentDownloadingFile!
        .copyWith(progress: progress, status: DownloadingStatus.donwloading);
    emit(state.copyWith(currentDownloadingFile: currentDownloadingFile));
  }

  Future<void> cancelDownload() async {
    if (state.currentDownloadingFile == null ||
        state.currentDownloadingFile!.status != DownloadingStatus.donwloading ||
        state.currentDownloadingFile!.taskId == null) {
      return;
    }

    FlutterDownloader.cancel(taskId: state.currentDownloadingFile!.taskId!);
    changeDownloadFileFailed();
  }

  Future<void> deleteFile({required DownloadedFile downloadedFile}) async {
    try {
      await hiveRepository.hiveDownloadedFilesBox.delete(downloadedFile.key);

      downloadedFile.localFile.deleteSync();
    } finally {
      loadAllDownloadedFiles();
    }
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }
}
