// ignore_for_file: unused_catch_stack

import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/files/files_rest.dart';
import 'package:zeusfile/data/statuses_cubit/network_status_cubit.dart';
import 'package:zeusfile/repository/files_repository.dart';

part 'files_state.dart';
part 'files_event.dart';
part 'files_bloc.g.dart';

class FilesBloc extends Bloc<FilesEvent, FilesState> {
  final FilesRepository filesRepository;
  final NetworkStatusCubit networkStatusCubit;

  FilesBloc({required this.filesRepository, required this.networkStatusCubit})
      : super(const FilesState()) {
    on<GetFiles>(_mapGetFilesEventToState);
    on<CreateFolder>(_mapCreateFolderEventToState);
    on<RenameFolder>(_mapRenameFolderEventToState);
    on<DeleteFolder>(_mapDeleteFolderEventToState);
    on<RenameFile>(_mapRenameFileEventToState);
    on<MoveFile>(_mapMoveFileEventToState);
    on<DeleteFile>(_mapDeleteFileEventToState);
  }

  void _mapGetFilesEventToState(
      GetFiles event, Emitter<FilesState> emit) async {
    networkStatusCubit.loading();
    try {
      final newServiceType = event.serviceType;

      var page = event.isPaginate == true ? state.currentPage + 1 : 1;

      //если пагинация то к существущим файлам добавляем что пришли с сервера
      List<FileObject> currentFiles =
          event.isPaginate == true ? state.userFiles?.files ?? [] : [];

      List<FolderObject> currentFolders =
          event.isPaginate == true ? state.userFiles?.folders ?? [] : [];

      FolderObject? currentSelectedFolder = event.folder;

      final selectedFolders = [...state.selectedFolder];

      if (currentSelectedFolder == null && selectedFolders.isNotEmpty) {
        selectedFolders.removeLast();
        currentSelectedFolder =
            selectedFolders.isNotEmpty ? selectedFolders.last : null;
      } else if (currentSelectedFolder != null &&
          selectedFolders.indexWhere(
                  (folder) => folder.id == currentSelectedFolder!.id) ==
              -1) {
        selectedFolders.add(currentSelectedFolder);
      }

      if (newServiceType != state.currentServiceType) {
        page = 1;
        currentFiles = [];
        currentFolders = [];
        currentSelectedFolder = null;
        selectedFolders.clear();
      }

      final result = await filesRepository.getFiles(event.session,
          folderId: currentSelectedFolder != null
              ? int.tryParse(currentSelectedFolder.id)
              : 0,
          page: page,
          serviceType: newServiceType);

      List<FolderObject> folders =
          result?.folders != null && result!.folders.isNotEmpty
              ? result.folders
              : currentFolders;

      currentFiles.addAll(result?.files ?? []);

      final userFiles = FilesResponse(
          folders: folders, files: currentFiles, pages: result?.pages ?? 0);

      emit(state.copyWith(
          userFiles: userFiles,
          pages: result?.pages,
          currentPage: page,
          selectedFolder: selectedFolders,
          pagination: false,
          currentServiceType: newServiceType));
    } catch (e, stacktrace) {
      // TODO show error
    } finally {
      networkStatusCubit.success();
    }
  }

  void _mapCreateFolderEventToState(
      CreateFolder event, Emitter<FilesState> emit) async {
    networkStatusCubit.loading();
    try {
      final result = await filesRepository.createFolder(
          event.session, event.folderName,
          serviceType: event.serviceType, parentFolderId: event.parentFolderId);
      if (result?.success == 1) {
        add(GetFiles(
            session: event.session,
            folder: state.selectedFolder.isNotEmpty
                ? state.selectedFolder.last
                : null,
            serviceType: event.serviceType));
      } else {
        // TODO show error
      }
    } catch (e, stacktrace) {
      // TODO show error
    } finally {
      networkStatusCubit.success();
    }
  }

  void _mapRenameFolderEventToState(
      RenameFolder event, Emitter<FilesState> emit) async {
    networkStatusCubit.loading();
    try {
      final result = await filesRepository.renameFolder(
          event.session, event.folderId, event.folderName,
          serviceType: event.serviceType);
      if (result?.success == 1) {
        add(GetFiles(
            session: event.session,
            folder: state.selectedFolder.isNotEmpty
                ? state.selectedFolder.last
                : null,
            serviceType: event.serviceType));
      } else {
        // TODO show error
      }
    } catch (e, stacktrace) {
      // TODO show error
    } finally {
      networkStatusCubit.success();
    }
  }

  void _mapDeleteFolderEventToState(
      DeleteFolder event, Emitter<FilesState> emit) async {
    networkStatusCubit.loading();
    try {
      final result = await filesRepository.deleteFolder(
          event.session, event.folderId,
          serviceType: event.serviceType);
      if (result?.success == 1) {
        add(GetFiles(
            session: event.session,
            folder: state.selectedFolder.isNotEmpty
                ? state.selectedFolder.last
                : null,
            serviceType: event.serviceType));
      } else {
        // TODO show error
      }
    } catch (e, stacktrace) {
      // TODO show error
    } finally {
      networkStatusCubit.success();
    }
  }

  void _mapRenameFileEventToState(
      RenameFile event, Emitter<FilesState> emit) async {
    networkStatusCubit.loading();
    try {
      final result = await filesRepository.renameFile(
          event.session, event.fileCode, event.fileName,
          serviceType: event.serviceType);
      if (result?.success == 1) {
        add(GetFiles(
            session: event.session,
            folder: state.selectedFolder.isNotEmpty
                ? state.selectedFolder.last
                : null,
            serviceType: event.serviceType));
      } else {
        // TODO show error
      }
    } catch (e, stacktrace) {
      // TODO show error
    } finally {
      networkStatusCubit.success();
    }
  }

  void _mapMoveFileEventToState(
      MoveFile event, Emitter<FilesState> emit) async {
    networkStatusCubit.loading();
    try {
      final result = await filesRepository.moveFile(
          event.session, event.fileCode, event.folderId,
          serviceType: event.serviceType);
      if (result?.success == 1) {
        add(GetFiles(
            session: event.session,
            folder: state.selectedFolder.isNotEmpty
                ? state.selectedFolder.last
                : null,
            serviceType: event.serviceType));
      } else {
        // TODO show error
      }
    } catch (e, stacktrace) {
      // TODO show error
    } finally {
      networkStatusCubit.success();
    }
  }

  void _mapDeleteFileEventToState(
      DeleteFile event, Emitter<FilesState> emit) async {
    networkStatusCubit.loading();
    try {
      final result = await filesRepository.deleteFile(
          event.session, event.fileCode,
          serviceType: event.serviceType);
      if (result?.success == 1) {
        add(GetFiles(
            session: event.session,
            folder: state.selectedFolder.isNotEmpty
                ? state.selectedFolder.last
                : null,
            serviceType: event.serviceType));
      } else {
        // TODO show error
      }
    } catch (e, stacktrace) {
      // TODO show error
    } finally {
      networkStatusCubit.success();
    }
  }
}
