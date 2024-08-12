// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_rest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadServerResponse _$DownloadServerResponseFromJson(
        Map<String, dynamic> json) =>
    DownloadServerResponse(
      downloadId: json['download_id'] as String?,
      fileSize: json['file_size'] as String?,
      fileName: json['file_name'] as String?,
      fileCode: json['file_code'] as String?,
      countdown: json['countdown'] as String?,
      error: json['error'] as int?,
      details: json['details'] as String?,
    );

Map<String, dynamic> _$DownloadServerResponseToJson(
        DownloadServerResponse instance) =>
    <String, dynamic>{
      'download_id': instance.downloadId,
      'file_size': instance.fileSize,
      'file_name': instance.fileName,
      'file_code': instance.fileCode,
      'countdown': instance.countdown,
      'error': instance.error,
      'details': instance.details,
    };

DownloadLinkResponse _$DownloadLinkResponseFromJson(
        Map<String, dynamic> json) =>
    DownloadLinkResponse(
      link: json['direct_link'] as String?,
      fileSize: json['file_size'] as String?,
      fileName: json['file_name'] as String?,
      fileCode: json['file_code'] as String?,
      error: json['error'] as int?,
      details: json['details'] as String?,
    );

Map<String, dynamic> _$DownloadLinkResponseToJson(
        DownloadLinkResponse instance) =>
    <String, dynamic>{
      'direct_link': instance.link,
      'file_size': instance.fileSize,
      'file_name': instance.fileName,
      'file_code': instance.fileCode,
      'error': instance.error,
      'details': instance.details,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _DownloadRest implements DownloadRest {
  _DownloadRest(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<DownloadServerResponse> downloadServer(
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
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DownloadServerResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              '/download/download1',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = DownloadServerResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<DownloadLinkResponse> downloadLink(
    session,
    file_code,
    download_id,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'session': session,
      'file_code': file_code,
      'download_id': download_id,
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<DownloadLinkResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              '/download/download2',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = DownloadLinkResponse.fromJson(_result.data!);
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
