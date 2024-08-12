// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_bloc.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DownloadStateCWProxy {
  DownloadState downloadId(String? downloadId);

  DownloadState downloadStatus(UploadStatus downloadStatus);

  DownloadState fileCode(String? fileCode);

  DownloadState link(String? link);

  DownloadState status(NetworkStatus status);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DownloadState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DownloadState(...).copyWith(id: 12, name: "My name")
  /// ````
  DownloadState call({
    String? downloadId,
    UploadStatus? downloadStatus,
    String? fileCode,
    String? link,
    NetworkStatus? status,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDownloadState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDownloadState.copyWith.fieldName(...)`
class _$DownloadStateCWProxyImpl implements _$DownloadStateCWProxy {
  final DownloadState _value;

  const _$DownloadStateCWProxyImpl(this._value);

  @override
  DownloadState downloadId(String? downloadId) => this(downloadId: downloadId);

  @override
  DownloadState downloadStatus(UploadStatus downloadStatus) =>
      this(downloadStatus: downloadStatus);

  @override
  DownloadState fileCode(String? fileCode) => this(fileCode: fileCode);

  @override
  DownloadState link(String? link) => this(link: link);

  @override
  DownloadState status(NetworkStatus status) => this(status: status);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DownloadState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DownloadState(...).copyWith(id: 12, name: "My name")
  /// ````
  DownloadState call({
    Object? downloadId = const $CopyWithPlaceholder(),
    Object? downloadStatus = const $CopyWithPlaceholder(),
    Object? fileCode = const $CopyWithPlaceholder(),
    Object? link = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
  }) {
    return DownloadState(
      downloadId: downloadId == const $CopyWithPlaceholder()
          ? _value.downloadId
          // ignore: cast_nullable_to_non_nullable
          : downloadId as String?,
      downloadStatus: downloadStatus == const $CopyWithPlaceholder() ||
              downloadStatus == null
          ? _value.downloadStatus
          // ignore: cast_nullable_to_non_nullable
          : downloadStatus as UploadStatus,
      fileCode: fileCode == const $CopyWithPlaceholder()
          ? _value.fileCode
          // ignore: cast_nullable_to_non_nullable
          : fileCode as String?,
      link: link == const $CopyWithPlaceholder()
          ? _value.link
          // ignore: cast_nullable_to_non_nullable
          : link as String?,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as NetworkStatus,
    );
  }
}

extension $DownloadStateCopyWith on DownloadState {
  /// Returns a callable class that can be used as follows: `instanceOfDownloadState.copyWith(...)` or like so:`instanceOfDownloadState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DownloadStateCWProxy get copyWith => _$DownloadStateCWProxyImpl(this);
}
