// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_types.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$DownloadedFileCWProxy {
  DownloadedFile dateTime(DateTime? dateTime);

  DownloadedFile downloadUrl(String downloadUrl);

  DownloadedFile fileCode(String fileCode);

  DownloadedFile fileName(String fileName);

  DownloadedFile localPath(String localPath);

  DownloadedFile serviceType(ServiceType serviceType);

  DownloadedFile size(int size);

  DownloadedFile url(String url);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DownloadedFile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DownloadedFile(...).copyWith(id: 12, name: "My name")
  /// ````
  DownloadedFile call({
    DateTime? dateTime,
    String? downloadUrl,
    String? fileCode,
    String? fileName,
    String? localPath,
    ServiceType? serviceType,
    int? size,
    String? url,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfDownloadedFile.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfDownloadedFile.copyWith.fieldName(...)`
class _$DownloadedFileCWProxyImpl implements _$DownloadedFileCWProxy {
  final DownloadedFile _value;

  const _$DownloadedFileCWProxyImpl(this._value);

  @override
  DownloadedFile dateTime(DateTime? dateTime) => this(dateTime: dateTime);

  @override
  DownloadedFile downloadUrl(String downloadUrl) =>
      this(downloadUrl: downloadUrl);

  @override
  DownloadedFile fileCode(String fileCode) => this(fileCode: fileCode);

  @override
  DownloadedFile fileName(String fileName) => this(fileName: fileName);

  @override
  DownloadedFile localPath(String localPath) => this(localPath: localPath);

  @override
  DownloadedFile serviceType(ServiceType serviceType) =>
      this(serviceType: serviceType);

  @override
  DownloadedFile size(int size) => this(size: size);

  @override
  DownloadedFile url(String url) => this(url: url);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `DownloadedFile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// DownloadedFile(...).copyWith(id: 12, name: "My name")
  /// ````
  DownloadedFile call({
    Object? dateTime = const $CopyWithPlaceholder(),
    Object? downloadUrl = const $CopyWithPlaceholder(),
    Object? fileCode = const $CopyWithPlaceholder(),
    Object? fileName = const $CopyWithPlaceholder(),
    Object? localPath = const $CopyWithPlaceholder(),
    Object? serviceType = const $CopyWithPlaceholder(),
    Object? size = const $CopyWithPlaceholder(),
    Object? url = const $CopyWithPlaceholder(),
  }) {
    return DownloadedFile(
      dateTime: dateTime == const $CopyWithPlaceholder()
          ? _value.dateTime
          // ignore: cast_nullable_to_non_nullable
          : dateTime as DateTime?,
      downloadUrl:
          downloadUrl == const $CopyWithPlaceholder() || downloadUrl == null
              ? _value.downloadUrl
              // ignore: cast_nullable_to_non_nullable
              : downloadUrl as String,
      fileCode: fileCode == const $CopyWithPlaceholder() || fileCode == null
          ? _value.fileCode
          // ignore: cast_nullable_to_non_nullable
          : fileCode as String,
      fileName: fileName == const $CopyWithPlaceholder() || fileName == null
          ? _value.fileName
          // ignore: cast_nullable_to_non_nullable
          : fileName as String,
      localPath: localPath == const $CopyWithPlaceholder() || localPath == null
          ? _value.localPath
          // ignore: cast_nullable_to_non_nullable
          : localPath as String,
      serviceType:
          serviceType == const $CopyWithPlaceholder() || serviceType == null
              ? _value.serviceType
              // ignore: cast_nullable_to_non_nullable
              : serviceType as ServiceType,
      size: size == const $CopyWithPlaceholder() || size == null
          ? _value.size
          // ignore: cast_nullable_to_non_nullable
          : size as int,
      url: url == const $CopyWithPlaceholder() || url == null
          ? _value.url
          // ignore: cast_nullable_to_non_nullable
          : url as String,
    );
  }
}

extension $DownloadedFileCopyWith on DownloadedFile {
  /// Returns a callable class that can be used as follows: `instanceOfDownloadedFile.copyWith(...)` or like so:`instanceOfDownloadedFile.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$DownloadedFileCWProxy get copyWith => _$DownloadedFileCWProxyImpl(this);
}

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadedFileAdapter extends TypeAdapter<DownloadedFile> {
  @override
  final int typeId = 1;

  @override
  DownloadedFile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloadedFile(
      url: fields[0] as String,
      downloadUrl: fields[1] as String,
      fileCode: fields[2] as String,
      serviceType: fields[3] as ServiceType,
      fileName: fields[4] as String,
      localPath: fields[5] as String,
      dateTime: fields[7] as DateTime?,
      size: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DownloadedFile obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.downloadUrl)
      ..writeByte(2)
      ..write(obj.fileCode)
      ..writeByte(3)
      ..write(obj.serviceType)
      ..writeByte(4)
      ..write(obj.fileName)
      ..writeByte(5)
      ..write(obj.localPath)
      ..writeByte(6)
      ..write(obj.size)
      ..writeByte(7)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadedFileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DownloadedFileStatusAdapter extends TypeAdapter<DownloadedFileStatus> {
  @override
  final int typeId = 4;

  @override
  DownloadedFileStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DownloadedFileStatus.fileExists;
      case 1:
        return DownloadedFileStatus.fileFullyDownloaded;
      case 2:
        return DownloadedFileStatus.fileNotExists;
      default:
        return DownloadedFileStatus.fileExists;
    }
  }

  @override
  void write(BinaryWriter writer, DownloadedFileStatus obj) {
    switch (obj) {
      case DownloadedFileStatus.fileExists:
        writer.writeByte(0);
        break;
      case DownloadedFileStatus.fileFullyDownloaded:
        writer.writeByte(1);
        break;
      case DownloadedFileStatus.fileNotExists:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadedFileStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
