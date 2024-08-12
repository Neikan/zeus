// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloaded_files_cubit.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DownloadingFileCWProxy {
  DownloadingFile currentDownloadedFile(DownloadedFile currentDownloadedFile);

  DownloadingFile progress(int progress);

  DownloadingFile status(DownloadingStatus status);

  DownloadingFile taskId(String? taskId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DownloadingFile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DownloadingFile(...).copyWith(id: 12, name: "My name")
  /// ````
  DownloadingFile call({
    DownloadedFile? currentDownloadedFile,
    int? progress,
    DownloadingStatus? status,
    String? taskId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDownloadingFile.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDownloadingFile.copyWith.fieldName(...)`
class _$DownloadingFileCWProxyImpl implements _$DownloadingFileCWProxy {
  final DownloadingFile _value;

  const _$DownloadingFileCWProxyImpl(this._value);

  @override
  DownloadingFile currentDownloadedFile(DownloadedFile currentDownloadedFile) =>
      this(currentDownloadedFile: currentDownloadedFile);

  @override
  DownloadingFile progress(int progress) => this(progress: progress);

  @override
  DownloadingFile status(DownloadingStatus status) => this(status: status);

  @override
  DownloadingFile taskId(String? taskId) => this(taskId: taskId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DownloadingFile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DownloadingFile(...).copyWith(id: 12, name: "My name")
  /// ````
  DownloadingFile call({
    Object? currentDownloadedFile = const $CopyWithPlaceholder(),
    Object? progress = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? taskId = const $CopyWithPlaceholder(),
  }) {
    return DownloadingFile(
      currentDownloadedFile:
          currentDownloadedFile == const $CopyWithPlaceholder() ||
                  currentDownloadedFile == null
              ? _value.currentDownloadedFile
              // ignore: cast_nullable_to_non_nullable
              : currentDownloadedFile as DownloadedFile,
      progress: progress == const $CopyWithPlaceholder() || progress == null
          ? _value.progress
          // ignore: cast_nullable_to_non_nullable
          : progress as int,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as DownloadingStatus,
      taskId: taskId == const $CopyWithPlaceholder()
          ? _value.taskId
          // ignore: cast_nullable_to_non_nullable
          : taskId as String?,
    );
  }
}

extension $DownloadingFileCopyWith on DownloadingFile {
  /// Returns a callable class that can be used as follows: `instanceOfDownloadingFile.copyWith(...)` or like so:`instanceOfDownloadingFile.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DownloadingFileCWProxy get copyWith => _$DownloadingFileCWProxyImpl(this);
}

abstract class _$DownloadedFilesCubitStateCWProxy {
  DownloadedFilesCubitState currentDownloadingFile(
      DownloadingFile? currentDownloadingFile);

  DownloadedFilesCubitState downloadedFiles(
      Map<String, DownloadedFile> downloadedFiles);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DownloadedFilesCubitState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DownloadedFilesCubitState(...).copyWith(id: 12, name: "My name")
  /// ````
  DownloadedFilesCubitState call({
    DownloadingFile? currentDownloadingFile,
    Map<String, DownloadedFile>? downloadedFiles,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDownloadedFilesCubitState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDownloadedFilesCubitState.copyWith.fieldName(...)`
class _$DownloadedFilesCubitStateCWProxyImpl
    implements _$DownloadedFilesCubitStateCWProxy {
  final DownloadedFilesCubitState _value;

  const _$DownloadedFilesCubitStateCWProxyImpl(this._value);

  @override
  DownloadedFilesCubitState currentDownloadingFile(
          DownloadingFile? currentDownloadingFile) =>
      this(currentDownloadingFile: currentDownloadingFile);

  @override
  DownloadedFilesCubitState downloadedFiles(
          Map<String, DownloadedFile> downloadedFiles) =>
      this(downloadedFiles: downloadedFiles);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DownloadedFilesCubitState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DownloadedFilesCubitState(...).copyWith(id: 12, name: "My name")
  /// ````
  DownloadedFilesCubitState call({
    Object? currentDownloadingFile = const $CopyWithPlaceholder(),
    Object? downloadedFiles = const $CopyWithPlaceholder(),
  }) {
    return DownloadedFilesCubitState(
      currentDownloadingFile:
          currentDownloadingFile == const $CopyWithPlaceholder()
              ? _value.currentDownloadingFile
              // ignore: cast_nullable_to_non_nullable
              : currentDownloadingFile as DownloadingFile?,
      downloadedFiles: downloadedFiles == const $CopyWithPlaceholder() ||
              downloadedFiles == null
          ? _value.downloadedFiles
          // ignore: cast_nullable_to_non_nullable
          : downloadedFiles as Map<String, DownloadedFile>,
    );
  }
}

extension $DownloadedFilesCubitStateCopyWith on DownloadedFilesCubitState {
  /// Returns a callable class that can be used as follows: `instanceOfDownloadedFilesCubitState.copyWith(...)` or like so:`instanceOfDownloadedFilesCubitState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DownloadedFilesCubitStateCWProxy get copyWith =>
      _$DownloadedFilesCubitStateCWProxyImpl(this);
}
