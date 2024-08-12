import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/dio.dart';
import 'package:zeusfile/repository/upload_repository.dart';
import 'package:zeusfile/utils/enums.dart';

part 'upload_state.dart';
part 'upload_event.dart';
part 'upload_bloc.g.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final UploadRepository uploadRepository;

  UploadBloc({required this.uploadRepository}) : super(const UploadState()) {
    on<UploadServer>(_mapUploadServerEventToState);
    on<UploadFiles>(_mapUploadFilesEventToState);
    on<UploadInit>(_mapUploadInitEventToState);
    on<UploadStart>(_mapUploadStartEventToState);
    on<UploadFinish>(_mapUploadFinishEventToState);
    on<UploadProgress>(_mapUploadProgressEventToState);
  }

  void _mapUploadServerEventToState(
      UploadServer event, Emitter<UploadState> emit) async {
    emit(state.copyWith(
        status: NetworkStatus.loading,
        serverId: null,
        serverUrl: null,
        uploadStatus: UploadStatus.initial));
    try {
      final result = await uploadRepository.upload(
          session: event.session, serviceType: event.serviceType);

      if (result == null) {
        emit(state.copyWith(
            status: NetworkStatus.error, uploadStatus: UploadStatus.error));
        return;
      }

      final serverId = int.parse(result.srvId.toString());

      emit(state.copyWith(
          status: NetworkStatus.success,
          serverId: serverId,
          serverUrl: result.url,
          uploadStatus: UploadStatus.ready,
          files: event.files));

      add(UploadStart(
          files: event.files,
          serverUrl: result.url,
          serviceType: event.serviceType,
          session: event.session,
          serverId: serverId));
      // ignore: unused_catch_stack
    } catch (e, stacktrace) {
      emit(state.copyWith(
          status: NetworkStatus.error, uploadStatus: UploadStatus.error));
    }
  }

  void _mapUploadStartEventToState(
      UploadStart event, Emitter<UploadState> emit) async {
    final cancelTok = CancelToken();
    emit(state.copyWith(
        status: NetworkStatus.loading,
        uploadStatus: UploadStatus.loading,
        files: event.files,
        cancelToken: cancelTok));
    try {
      // ignore: no_leading_underscores_for_local_identifiers
      final _dio = dioInstance();
      final formData = {
        'sess_id': event.session,
        'upload_type': 'file',
        'srv_id': event.serverId,
        'to_json': 1
      };

      for (var i = 0; i < event.files.length; i++) {
        final file = File(event.files[i].path!);
        formData.addAll({
          'file_${i + 1}': MultipartFile(file.openRead(), file.lengthSync(),
              filename: event.files[i].name,
              contentType: MediaType.parse(
                  lookupMimeType(file.path) ?? 'application/octet-stream'))
        });
      }

      _dio.options.headers = {'Content-Type': 'multipart/form-data'};

      await _dio.post(
        event.serverUrl,
        data: FormData.fromMap(formData),
        cancelToken: cancelTok,
        onSendProgress: (count, total) {
          add(UploadProgress(
              countBytes: count,
              progress: count / total,
              totalBytes: total,
              serviceType: event.serviceType));
        },
      );
      add(const UploadFinish());
    } catch (e) {
      emit(state.copyWith(
          status: NetworkStatus.error, uploadStatus: UploadStatus.error));
    }
  }

  void _mapUploadFinishEventToState(
      UploadFinish event, Emitter<UploadState> emit) {
    emit(state.copyWith(
        status: NetworkStatus.success, uploadStatus: UploadStatus.uploaded));
  }

  void _mapUploadProgressEventToState(
      UploadProgress event, Emitter<UploadState> emit) {
    emit(state.copyWith(
        progress: event.progress,
        countBytes: event.countBytes,
        totalBytes: event.totalBytes));
  }

  void _mapUploadInitEventToState(UploadInit event, Emitter<UploadState> emit) {
    emit(state.copyWith(
        status: NetworkStatus.initial,
        uploadStatus: UploadStatus.initial,
        files: []));
  }

  void _mapUploadFilesEventToState(
      UploadFiles event, Emitter<UploadState> emit) async {
    emit(state.copyWith(
        status: NetworkStatus.loading, uploadStatus: UploadStatus.loading));
    try {
      // ignore: unused_local_variable
      final result = await uploadRepository.uploadFinish(
          session: event.session,
          serverId: event.serverId,
          file: event.file,
          serviceType: event.serviceType);
      emit(state.copyWith(
          status: NetworkStatus.success, uploadStatus: UploadStatus.uploaded));
      // ignore: unused_catch_stack
    } catch (e, stacktrace) {
      emit(state.copyWith(
          status: NetworkStatus.error, uploadStatus: UploadStatus.error));
    }
  }
}
