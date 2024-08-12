part of 'upload_bloc.dart';

@CopyWith()
class UploadState extends Equatable {
  final NetworkStatus status;
  final int? serverId;
  final String? serverUrl;
  final UploadStatus uploadStatus;

  final double progress;
  final int countBytes;
  final int totalBytes;
  final List<PlatformFile> files;
  final CancelToken? cancelToken;

  const UploadState(
      {this.status = NetworkStatus.initial,
      this.serverId,
      this.serverUrl,
      this.uploadStatus = UploadStatus.initial,
      this.countBytes = 0,
      this.progress = 0,
      this.totalBytes = 0,
      this.files = const [],
      this.cancelToken});

  @override
  List<Object?> get props => [
        status,
        serverId,
        serverUrl,
        uploadStatus,
        progress,
        countBytes,
        totalBytes,
        files,
        cancelToken
      ];
}
