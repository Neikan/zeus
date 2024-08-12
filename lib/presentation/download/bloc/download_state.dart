part of 'download_bloc.dart';

@CopyWith()
class DownloadState extends Equatable {
  final NetworkStatus status;
  final UploadStatus downloadStatus;
  final String? downloadId;
  final String? fileCode;
  final String? link;

  const DownloadState(
      {this.status = NetworkStatus.initial,
      this.downloadStatus = UploadStatus.initial,
      this.downloadId,
      this.fileCode,
      this.link});

  @override
  List<Object?> get props =>
      [status, downloadStatus, downloadId, fileCode, link];
}
