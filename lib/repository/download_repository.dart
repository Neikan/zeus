// ignore_for_file: avoid_print

import 'package:zeusfile/data/download/download_rest.dart';

class DownloadRepository {
  final DownloadRest downloadRest;

  const DownloadRepository({required this.downloadRest});

  Future<DownloadServerResponse?> download(
      String session, String fileCode) async {
    try {
      final response = await downloadRest.downloadServer(session, fileCode);

      return response;
    } catch (e) {
      print('DOWNLOAD ERROR: $e');
      return null;
    }
  }

  Future<DownloadLinkResponse?> downloadLink(
      String session, String fileCode, String downloadId) async {
    try {
      final response =
          await downloadRest.downloadLink(session, fileCode, downloadId);

      return response;
    } catch (e) {
      print('DOWNLOAD LINK ERROR: $e');
      return null;
    }
  }
}
