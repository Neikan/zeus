import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeusfile/utils/enums.dart';

class UploadStatusCubit extends Cubit<UploadStatus> {
  UploadStatusCubit() : super(UploadStatus.initial);

  void initial() => emit(UploadStatus.initial);
  void loading() => emit(UploadStatus.loading);
  void ready() => emit(UploadStatus.ready);
  void uploaded() => emit(UploadStatus.uploaded);
  void error() => emit(UploadStatus.error);
}
