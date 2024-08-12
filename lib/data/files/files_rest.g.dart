// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'files_rest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilesResponse _$FilesResponseFromJson(Map<String, dynamic> json) =>
    FilesResponse(
      folders: (json['folders'] as List<dynamic>)
          .map((e) => FolderObject.fromJson(e as Map<String, dynamic>))
          .toList(),
      files: (json['files'] as List<dynamic>)
          .map((e) => FileObject.fromJson(e as Map<String, dynamic>))
          .toList(),
      pages: json['pages'] as int,
    );

Map<String, dynamic> _$FilesResponseToJson(FilesResponse instance) =>
    <String, dynamic>{
      'folders': instance.folders,
      'files': instance.files,
      'pages': instance.pages,
    };

CreateFolderResponse _$CreateFolderResponseFromJson(
        Map<String, dynamic> json) =>
    CreateFolderResponse(
      success: json['success'] as int?,
      error: json['error'] as int?,
      details: json['details'] as String?,
      folderId: json['fld_id'] as String?,
    );

Map<String, dynamic> _$CreateFolderResponseToJson(
        CreateFolderResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'details': instance.details,
      'fld_id': instance.folderId,
    };

FolderResponse _$FolderResponseFromJson(Map<String, dynamic> json) =>
    FolderResponse(
      success: json['success'] as int?,
      error: json['error'] as int?,
      details: json['details'] as String?,
    );

Map<String, dynamic> _$FolderResponseToJson(FolderResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'error': instance.error,
      'details': instance.details,
    };

FileObject _$FileObjectFromJson(Map<String, dynamic> json) => FileObject(
      fileCode: json['file_code'] as String?,
      shortCode: json['short_code'] as String?,
      name: json['file_name'] as String,
      size: json['file_size'] as String,
      created: json['created'] as String,
    );

Map<String, dynamic> _$FileObjectToJson(FileObject instance) =>
    <String, dynamic>{
      'file_code': instance.fileCode,
      'short_code': instance.shortCode,
      'file_name': instance.name,
      'file_size': instance.size,
      'created': instance.created,
    };

FolderObject _$FolderObjectFromJson(Map<String, dynamic> json) => FolderObject(
      id: json['fld_id'] as String,
      name: json['fld_name'] as String,
      files: json['fld_files'] as String,
    );

Map<String, dynamic> _$FolderObjectToJson(FolderObject instance) =>
    <String, dynamic>{
      'fld_id': instance.id,
      'fld_name': instance.name,
      'fld_files': instance.files,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _FilesRest implements FilesRest {
  _FilesRest(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<FilesResponse> getFiles(
    session,
    fld_id,
    page,
    per_page,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'session': session,
      'fld_id': fld_id,
      'page': page,
      'per_page': per_page,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<FilesResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              '/files/my_files',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = FilesResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CreateFolderResponse> createFolder(
    session,
    fld_name,
    fld_id,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'session': session,
      'fld_name': fld_name,
      'fld_id': fld_id,
    };
    _data.removeWhere((k, v) => v == null);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CreateFolderResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              '/folders/folder_create',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CreateFolderResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<FolderResponse> renameFolder(
    session,
    fld_id,
    fld_name,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'session': session,
      'fld_id': fld_id,
      'fld_name': fld_name,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<FolderResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              '/folders/folder_edit',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = FolderResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<FolderResponse> deleteFolder(
    session,
    fld_id,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'session': session,
      'fld_id': fld_id,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<FolderResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              '/folders/folder_delete',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = FolderResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<FolderResponse> deleteFile(
    session,
    file_code,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'session': session,
      'file_code': file_code,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<FolderResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              '/files/file_delete',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = FolderResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<FolderResponse> renameFile(
    session,
    file_code,
    file_name,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'session': session,
      'file_code': file_code,
      'file_name': file_name,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<FolderResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              '/files/file_edit',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = FolderResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<FolderResponse> moveFile(
    session,
    file_code,
    fld_id,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'session': session,
      'file_code': file_code,
      'fld_id': fld_id,
    };
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<FolderResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              '/files/file_move',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = FolderResponse.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
