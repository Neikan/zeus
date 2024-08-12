// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_bloc.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FilesStateCWProxy {
  FilesState currentPage(int currentPage);

  FilesState currentServiceType(ServiceType? currentServiceType);

  FilesState pages(int pages);

  FilesState pagination(bool pagination);

  FilesState selectedFolder(List<FolderObject> selectedFolder);

  FilesState userFiles(FilesResponse? userFiles);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FilesState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FilesState(...).copyWith(id: 12, name: "My name")
  /// ````
  FilesState call({
    int? currentPage,
    ServiceType? currentServiceType,
    int? pages,
    bool? pagination,
    List<FolderObject>? selectedFolder,
    FilesResponse? userFiles,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFilesState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFilesState.copyWith.fieldName(...)`
class _$FilesStateCWProxyImpl implements _$FilesStateCWProxy {
  final FilesState _value;

  const _$FilesStateCWProxyImpl(this._value);

  @override
  FilesState currentPage(int currentPage) => this(currentPage: currentPage);

  @override
  FilesState currentServiceType(ServiceType? currentServiceType) =>
      this(currentServiceType: currentServiceType);

  @override
  FilesState pages(int pages) => this(pages: pages);

  @override
  FilesState pagination(bool pagination) => this(pagination: pagination);

  @override
  FilesState selectedFolder(List<FolderObject> selectedFolder) =>
      this(selectedFolder: selectedFolder);

  @override
  FilesState userFiles(FilesResponse? userFiles) => this(userFiles: userFiles);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FilesState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FilesState(...).copyWith(id: 12, name: "My name")
  /// ````
  FilesState call({
    Object? currentPage = const $CopyWithPlaceholder(),
    Object? currentServiceType = const $CopyWithPlaceholder(),
    Object? pages = const $CopyWithPlaceholder(),
    Object? pagination = const $CopyWithPlaceholder(),
    Object? selectedFolder = const $CopyWithPlaceholder(),
    Object? userFiles = const $CopyWithPlaceholder(),
  }) {
    return FilesState(
      currentPage:
          currentPage == const $CopyWithPlaceholder() || currentPage == null
              ? _value.currentPage
              // ignore: cast_nullable_to_non_nullable
              : currentPage as int,
      currentServiceType: currentServiceType == const $CopyWithPlaceholder()
          ? _value.currentServiceType
          // ignore: cast_nullable_to_non_nullable
          : currentServiceType as ServiceType?,
      pages: pages == const $CopyWithPlaceholder() || pages == null
          ? _value.pages
          // ignore: cast_nullable_to_non_nullable
          : pages as int,
      pagination:
          pagination == const $CopyWithPlaceholder() || pagination == null
              ? _value.pagination
              // ignore: cast_nullable_to_non_nullable
              : pagination as bool,
      selectedFolder: selectedFolder == const $CopyWithPlaceholder() ||
              selectedFolder == null
          ? _value.selectedFolder
          // ignore: cast_nullable_to_non_nullable
          : selectedFolder as List<FolderObject>,
      userFiles: userFiles == const $CopyWithPlaceholder()
          ? _value.userFiles
          // ignore: cast_nullable_to_non_nullable
          : userFiles as FilesResponse?,
    );
  }
}

extension $FilesStateCopyWith on FilesState {
  /// Returns a callable class that can be used as follows: `instanceOfFilesState.copyWith(...)` or like so:`instanceOfFilesState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FilesStateCWProxy get copyWith => _$FilesStateCWProxyImpl(this);
}
