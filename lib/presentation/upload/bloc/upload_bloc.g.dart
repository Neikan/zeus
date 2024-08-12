// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_bloc.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UploadStateCWProxy {
  UploadState cancelToken(CancelToken? cancelToken);

  UploadState countBytes(int countBytes);

  UploadState files(List<PlatformFile> files);

  UploadState progress(double progress);

  UploadState serverId(int? serverId);

  UploadState serverUrl(String? serverUrl);

  UploadState status(NetworkStatus status);

  UploadState totalBytes(int totalBytes);

  UploadState uploadStatus(UploadStatus uploadStatus);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UploadState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UploadState(...).copyWith(id: 12, name: "My name")
  /// ````
  UploadState call({
    CancelToken? cancelToken,
    int? countBytes,
    List<PlatformFile>? files,
    double? progress,
    int? serverId,
    String? serverUrl,
    NetworkStatus? status,
    int? totalBytes,
    UploadStatus? uploadStatus,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUploadState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUploadState.copyWith.fieldName(...)`
class _$UploadStateCWProxyImpl implements _$UploadStateCWProxy {
  final UploadState _value;

  const _$UploadStateCWProxyImpl(this._value);

  @override
  UploadState cancelToken(CancelToken? cancelToken) =>
      this(cancelToken: cancelToken);

  @override
  UploadState countBytes(int countBytes) => this(countBytes: countBytes);

  @override
  UploadState files(List<PlatformFile> files) => this(files: files);

  @override
  UploadState progress(double progress) => this(progress: progress);

  @override
  UploadState serverId(int? serverId) => this(serverId: serverId);

  @override
  UploadState serverUrl(String? serverUrl) => this(serverUrl: serverUrl);

  @override
  UploadState status(NetworkStatus status) => this(status: status);

  @override
  UploadState totalBytes(int totalBytes) => this(totalBytes: totalBytes);

  @override
  UploadState uploadStatus(UploadStatus uploadStatus) =>
      this(uploadStatus: uploadStatus);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UploadState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UploadState(...).copyWith(id: 12, name: "My name")
  /// ````
  UploadState call({
    Object? cancelToken = const $CopyWithPlaceholder(),
    Object? countBytes = const $CopyWithPlaceholder(),
    Object? files = const $CopyWithPlaceholder(),
    Object? progress = const $CopyWithPlaceholder(),
    Object? serverId = const $CopyWithPlaceholder(),
    Object? serverUrl = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? totalBytes = const $CopyWithPlaceholder(),
    Object? uploadStatus = const $CopyWithPlaceholder(),
  }) {
    return UploadState(
      cancelToken: cancelToken == const $CopyWithPlaceholder()
          ? _value.cancelToken
          // ignore: cast_nullable_to_non_nullable
          : cancelToken as CancelToken?,
      countBytes:
          countBytes == const $CopyWithPlaceholder() || countBytes == null
              ? _value.countBytes
              // ignore: cast_nullable_to_non_nullable
              : countBytes as int,
      files: files == const $CopyWithPlaceholder() || files == null
          ? _value.files
          // ignore: cast_nullable_to_non_nullable
          : files as List<PlatformFile>,
      progress: progress == const $CopyWithPlaceholder() || progress == null
          ? _value.progress
          // ignore: cast_nullable_to_non_nullable
          : progress as double,
      serverId: serverId == const $CopyWithPlaceholder()
          ? _value.serverId
          // ignore: cast_nullable_to_non_nullable
          : serverId as int?,
      serverUrl: serverUrl == const $CopyWithPlaceholder()
          ? _value.serverUrl
          // ignore: cast_nullable_to_non_nullable
          : serverUrl as String?,
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as NetworkStatus,
      totalBytes:
          totalBytes == const $CopyWithPlaceholder() || totalBytes == null
              ? _value.totalBytes
              // ignore: cast_nullable_to_non_nullable
              : totalBytes as int,
      uploadStatus:
          uploadStatus == const $CopyWithPlaceholder() || uploadStatus == null
              ? _value.uploadStatus
              // ignore: cast_nullable_to_non_nullable
              : uploadStatus as UploadStatus,
    );
  }
}

extension $UploadStateCopyWith on UploadState {
  /// Returns a callable class that can be used as follows: `instanceOfUploadState.copyWith(...)` or like so:`instanceOfUploadState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UploadStateCWProxy get copyWith => _$UploadStateCWProxyImpl(this);
}
