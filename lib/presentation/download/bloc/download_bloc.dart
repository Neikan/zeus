// ignore_for_file: unused_catch_stack

import 'package:clipboard/clipboard.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zeusfile/data/dio.dart';
import 'package:zeusfile/presentation/widgets/popup_item.dart';
import 'package:zeusfile/repository/download_repository.dart';
import 'package:zeusfile/utils/downloader.dart';
import 'package:zeusfile/utils/enums.dart';

part 'download_state.dart';
part 'download_event.dart';
part 'download_bloc.g.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  final DownloadRepository downloadRepository;

  DownloadBloc({required this.downloadRepository})
      : super(const DownloadState()) {
    on<DownloadServer>(_mapDownloadServerEventToState);
    on<DownloadFile>(_mapDownloadFileEventToState);
  }

  void _mapDownloadFileEventToState(
      DownloadFile event, Emitter<DownloadState> emit) {
    downloadFile(dioInstance(), event.link,
        event.link.substring(event.link.lastIndexOf('/') + 1));
  }

  void _mapDownloadServerEventToState(
      DownloadServer event, Emitter<DownloadState> emit) async {
    emit(state.copyWith(
        status: NetworkStatus.loading, downloadStatus: UploadStatus.loading));
    try {
      final result =
          await downloadRepository.download(event.session, event.fileCode);
      if (result?.downloadId != null) {
        await Future.delayed(const Duration(seconds: 0), () async {
          final resultLink = await downloadRepository.downloadLink(
              event.session, event.fileCode, result!.downloadId!);

          if (resultLink?.link != null && event.isDownload == true) {
            downloadFile(
                dioInstance(), resultLink!.link!, resultLink.fileName!);
          }

          if (event.isDownload == false) {
            FlutterClipboard.copy(resultLink?.link ?? '').then((value) {
              FToast().removeQueuedCustomToasts();
              FToast().showToast(
                  gravity: ToastGravity.TOP,
                  toastDuration: const Duration(seconds: 3),
                  child: PopUpItem(
                    text: 'Link copied',
                    onTap: () {
                      FToast().removeQueuedCustomToasts();
                    },
                  ));
            });
          }

          emit(state.copyWith(
              status: NetworkStatus.success,
              downloadStatus: UploadStatus.ready,
              downloadId: result.downloadId,
              fileCode: result.fileCode,
              link: resultLink?.link));
        });
      } else {
        emit(state.copyWith(
            status: NetworkStatus.error,
            downloadStatus: UploadStatus.error,
            downloadId: result?.downloadId,
            fileCode: result?.fileCode));
      }
    } catch (e, stacktrace) {
      emit(state.copyWith(
          status: NetworkStatus.error, downloadStatus: UploadStatus.error));
    }
  }
}
