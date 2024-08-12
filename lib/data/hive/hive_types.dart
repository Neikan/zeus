import 'dart:io';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mime/mime.dart';
import 'package:zeusfile/constants.dart';

part 'hive_types.g.dart';

@HiveType(typeId: 4)
enum DownloadedFileStatus {
  @HiveField(0)
  fileExists,
  @HiveField(1)
  fileFullyDownloaded,
  @HiveField(2)
  fileNotExists,
}

enum FileType { music, video, pdf, document, file, image }

extension FileTypeExtension on FileType {
  static const audioMimeType = 'audio';
  static const videoMimeType = 'video';
  static const imageMimeType = 'image';
  static const pdfMimeType = 'application/pdf';
  static const docMimeType = 'application/msword';
  static const openxmlMimeType = 'application/vnd.';
  static const defaultBinaryData = 'application/octet-stream';

  static const Map<String, FileType> defaults = {
    defaultBinaryData: FileType.file,
    audioMimeType: FileType.music,
    videoMimeType: FileType.video,
    imageMimeType: FileType.image,
    pdfMimeType: FileType.pdf,
    docMimeType: FileType.document,
    openxmlMimeType: FileType.document,
  };

  static const Map<String, FileType> defaultsExtension = {
    defaultBinaryData: FileType.file,
    '3gp': FileType.video,
    'mpg': FileType.video,
    'mpeg': FileType.video,
    'mp4': FileType.video,
    'm4v': FileType.video,
    'm4p': FileType.video,
    'ogv': FileType.video,
    'mov': FileType.video,
    'webm': FileType.video,
    'avi': FileType.video,
    'mkv': FileType.video,
    'aac': FileType.music,
    'mp3': FileType.music,
    'oga': FileType.music,
    'ogg': FileType.music,
    'wav': FileType.music,
  };

  String get callToActionRepresent {
    switch (this) {
      case FileType.music:
        return 'Listen';
      case FileType.video:
        return 'Watch';
      case FileType.pdf:
        return 'Open';
      case FileType.document:
        return 'Open';
      case FileType.file:
        return 'Open';
      case FileType.image:
        return 'View';
    }
  }

  static String getDefaultsKey(String mimeType) => defaults.keys.firstWhere(
      (mimeTypePattern) => mimeType.toLowerCase().startsWith(mimeTypePattern),
      orElse: () => defaultBinaryData);

  static String getDefaultsExtensionKey(String fileName) =>
      defaultsExtension.keys.firstWhere(
          (extensionPattern) =>
              fileName.toLowerCase().endsWith(extensionPattern),
          orElse: () => defaultBinaryData);

  FileType getFileType(String? mimeType) =>
      mimeType == null ? this : defaults[getDefaultsKey(mimeType)] ?? this;

  FileType getFileTypeByExtension(String fileName) =>
      defaultsExtension[getDefaultsExtensionKey(fileName)] ?? this;
}

@HiveType(typeId: 1)
@CopyWith()
@immutable
class DownloadedFile {
  // URL
  @HiveField(0)
  final String url;

  // DownloadUrl
  @HiveField(1)
  final String downloadUrl;

  @HiveField(2)
  final String fileCode;

  // Download file Service Type
  @HiveField(3)
  final ServiceType serviceType;

  // File name
  @HiveField(4)
  final String fileName;

  // Local path
  @HiveField(5)
  final String localPath;

  // File size
  @HiveField(6)
  final int size;

  // File datetime
  @HiveField(7)
  final DateTime dateTime;

  File get localFile => File(localPath);

  PlatformFile get localPlatformFile =>
      PlatformFile(path: localPath, name: fileName, size: size);

  DownloadedFileStatus get fileStatus {
    if (!localFile.existsSync()) return DownloadedFileStatus.fileNotExists;
    if (localFile.statSync().size == size) {
      // TODO checking file size
      return DownloadedFileStatus.fileFullyDownloaded;
    }
    return DownloadedFileStatus.fileExists;
  }

  String? get mimeType => fileStatus == DownloadedFileStatus.fileNotExists
      ? null
      : lookupMimeType(localPath);

  FileType get fileType => FileType.file.getFileType(mimeType);

  DownloadedFile(
      {required this.url,
      required this.downloadUrl,
      required this.fileCode,
      required this.serviceType,
      required this.fileName,
      required this.localPath,
      DateTime? dateTime,
      required this.size})
      : dateTime = dateTime ?? DateTime.now();

  String get key => url;
}
