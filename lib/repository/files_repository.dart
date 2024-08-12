// ignore_for_file: avoid_print

import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/files/files_rest.dart';

class FilesRepository {
  final ExtendedFilesRest filesRest;

  FilesRepository({required this.filesRest});

  Future<FilesResponse?> getFiles(String session,
      {int? folderId, int? page, required ServiceType serviceType}) async {
    try {
      final response = await filesRest
          .by(serviceType)
          .getFiles(session, folderId ?? 0, page ?? 1, 20);

      return response;
    } catch (e) {
      print('UPLOAD ERROR: $e');
      return null;
    }
  }

  Future<CreateFolderResponse?> createFolder(String session, String folderName,
      {required ServiceType serviceType, required int? parentFolderId}) async {
    try {
      final response = await filesRest
          .by(serviceType)
          .createFolder(session, folderName, parentFolderId);

      return response;
    } catch (e) {
      print('CREATE FOLDER ERROR: $e');
      return null;
    }
  }

  Future<FolderResponse?> renameFolder(
      String session, int folderId, String folderName,
      {required ServiceType serviceType}) async {
    try {
      final response = await filesRest
          .by(serviceType)
          .renameFolder(session, folderId, folderName);

      return response;
    } catch (e) {
      print('RENAME FOLDER ERROR: $e');
      return null;
    }
  }

  Future<FolderResponse?> deleteFolder(String session, String folderId,
      {required ServiceType serviceType}) async {
    try {
      final response =
          await filesRest.by(serviceType).deleteFolder(session, folderId);

      return response;
    } catch (e) {
      print('DELETE FOLDER ERROR: $e');
      return null;
    }
  }

  Future<FolderResponse?> renameFile(
      String session, String fileCode, String fileName,
      {required ServiceType serviceType}) async {
    try {
      final response = await filesRest
          .by(serviceType)
          .renameFile(session, fileCode, fileName);

      return response;
    } catch (e) {
      print('RENAME FILE ERROR: $e');
      return null;
    }
  }

  Future<FolderResponse?> moveFile(
      String session, String fileCode, int folderId,
      {required ServiceType serviceType}) async {
    try {
      final response =
          await filesRest.by(serviceType).moveFile(session, fileCode, folderId);

      return response;
    } catch (e) {
      print('MOVE FILE ERROR: $e');
      return null;
    }
  }

  Future<FolderResponse?> deleteFile(String session, String fileCode,
      {required ServiceType serviceType}) async {
    try {
      final response =
          await filesRest.by(serviceType).deleteFile(session, fileCode);

      return response;
    } catch (e) {
      print('DELETE FILE ERROR: $e');
      return null;
    }
  }
}
