// ignore_for_file: avoid_print

import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/upload/upload_rest.dart';

class UploadRepository {
  final ExtendedUploadRest extendedUploadRest;

  const UploadRepository({required this.extendedUploadRest});

  Future<UploadResponse?> upload(
      {required String session, required ServiceType serviceType}) async {
    try {
      final response =
          await extendedUploadRest.by(serviceType).uploadServer(session);

      return response;
    } catch (e) {
      print('UPLOAD ERROR: $e');
      return null;
    }
  }

  Future<UploadFinishResponse?> uploadFinish(
      {required String session,
      required int serverId,
      required String file,
      required ServiceType serviceType}) async {
    try {
      final response = await extendedUploadRest
          .by(serviceType)
          .upload(session, 'file', serverId, 1, file);

      return response;
    } catch (e) {
      return null;
    }
  }
}
