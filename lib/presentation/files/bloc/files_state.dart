part of 'files_bloc.dart';

@CopyWith()
class FilesState extends Equatable {
  final ServiceType? currentServiceType;
  final bool pagination;
  final FilesResponse? userFiles;
  final List<FolderObject> selectedFolder;
  final int currentPage;
  final int pages;

  const FilesState(
      {this.currentServiceType,
      this.userFiles,
      this.selectedFolder = const [],
      this.currentPage = 0,
      this.pages = 0,
      this.pagination = false});

  List<FileObject> searchFiles({required String fileName}) => [
        ...?userFiles?.files
            .where((file) =>
                fileName.trim().isEmpty ||
                file.name.toLowerCase().contains(fileName.trim().toLowerCase()))
            .toList()
      ];

  @override
  List<Object?> get props =>
      [userFiles, selectedFolder, currentPage, pages, pagination];
}
