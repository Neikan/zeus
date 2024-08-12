part of 'download_bloc.dart';

class DownloadEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class DownloadServer extends DownloadEvent {
  final String session;
  final String fileCode;
  final bool isDownload;

  DownloadServer(
      {required this.session,
      required this.fileCode,
      required this.isDownload});

  @override
  List<Object?> get props => [session, fileCode, isDownload];
}

class DownloadFile extends DownloadEvent {
  final String link;

  DownloadFile({required this.link});

  @override
  List<Object?> get props => [link];
}
