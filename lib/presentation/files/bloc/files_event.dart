part of 'files_bloc.dart';

abstract class FilesEvent extends Equatable {
  final ServiceType serviceType;

  const FilesEvent({required this.serviceType});

  @override
  List<Object?> get props => [serviceType];
}

class GetFiles extends FilesEvent {
  final String session;
  final FolderObject? folder;
  final bool? isPaginate;

  const GetFiles(
      {required this.session,
      this.folder,
      this.isPaginate,
      required super.serviceType});

  @override
  List<Object?> get props => [session, folder, isPaginate];
}

class CreateFolder extends FilesEvent {
  final String session;
  final String folderName;
  final int? parentFolderId;

  const CreateFolder({
    required this.session,
    required this.folderName,
    required this.parentFolderId,
    required super.serviceType,
  });

  @override
  List<Object?> get props => [session, folderName, parentFolderId];
}

class DeleteFolder extends FilesEvent {
  final String session;
  final String folderId;

  const DeleteFolder(
      {required this.session,
      required this.folderId,
      required super.serviceType});

  @override
  List<Object?> get props => [session, folderId];
}

class RenameFolder extends FilesEvent {
  final String session;
  final String folderName;
  final int folderId;

  const RenameFolder(
      {required this.session,
      required this.folderId,
      required this.folderName,
      required super.serviceType});

  @override
  List<Object?> get props => [session, folderId, folderName];
}

class DeleteFile extends FilesEvent {
  final String session;
  final String fileCode;

  const DeleteFile(
      {required this.session,
      required this.fileCode,
      required super.serviceType});

  @override
  List<Object?> get props => [session, fileCode];
}

class RenameFile extends FilesEvent {
  final String session;
  final String fileName;
  final String fileCode;

  const RenameFile(
      {required this.session,
      required this.fileCode,
      required this.fileName,
      required super.serviceType});

  @override
  List<Object?> get props => [session, fileCode, fileName];
}

class MoveFile extends FilesEvent {
  final String session;
  final int folderId;
  final String fileCode;

  const MoveFile(
      {required this.session,
      required this.fileCode,
      required this.folderId,
      required super.serviceType});

  @override
  List<Object?> get props => [session, fileCode, folderId];
}

class SelectFolder extends FilesEvent {
  final FolderObject? folder;

  const SelectFolder({this.folder, required super.serviceType});

  @override
  List<Object?> get props => [folder];
}
