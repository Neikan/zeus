part of 'upload_bloc.dart';

abstract class UploadEvent extends Equatable {
  final ServiceType serviceType;

  const UploadEvent({required this.serviceType});

  @override
  List<Object?> get props => [serviceType];
}

class UploadServer extends UploadEvent {
  final String session;
  final List<PlatformFile> files;

  const UploadServer(
      {required this.session, required super.serviceType, required this.files});
  @override
  List<Object?> get props => [session, serviceType];
}

class UploadInit extends UploadEvent {
  const UploadInit({super.serviceType = ServiceType.filejoker});
}

class UploadStart extends UploadEvent {
  final String session;
  final List<PlatformFile> files;
  final int? serverId;
  final String serverUrl;

  const UploadStart(
      {required this.session,
      required this.files,
      this.serverId,
      required this.serverUrl,
      required super.serviceType});

  @override
  List<Object?> get props => [session, files, serverId, serverUrl];
}

class UploadFinish extends UploadEvent {
  const UploadFinish({super.serviceType = ServiceType.filejoker});
}

class UploadProgress extends UploadEvent {
  final double progress;
  final int countBytes;
  final int totalBytes;

  const UploadProgress(
      {required this.countBytes,
      required this.progress,
      required this.totalBytes,
      required super.serviceType});

  @override
  List<Object?> get props => [countBytes, progress, totalBytes, serviceType];
}

class UploadFiles extends UploadEvent {
  final String session;
  final int serverId;
  final String file;

  const UploadFiles(
      {required this.session,
      required this.serverId,
      required this.file,
      required super.serviceType});

  @override
  List<Object?> get props => [session, serverId, file, serviceType];
}
