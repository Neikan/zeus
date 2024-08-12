// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_rest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadResponse _$UploadResponseFromJson(Map<String, dynamic> json) =>
    UploadResponse(
      srvId: json['srv_id'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$UploadResponseToJson(UploadResponse instance) =>
    <String, dynamic>{
      'srv_id': instance.srvId,
      'url': instance.url,
    };

UploadFinishResponse _$UploadFinishResponseFromJson(
        Map<String, dynamic> json) =>
    UploadFinishResponse(
      result: (json['result'] as List<dynamic>)
          .map((e) => UploadInfoResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UploadFinishResponseToJson(
        UploadFinishResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
    };

UploadInfoResponse _$UploadInfoResponseFromJson(Map<String, dynamic> json) =>
    UploadInfoResponse(
      st: json['st'] as String,
      fn: json['fn'] as String,
    );

Map<String, dynamic> _$UploadInfoResponseToJson(UploadInfoResponse instance) =>
    <String, dynamic>{
      'st': instance.st,
      'fn': instance.fn,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _UploadRest implements UploadRest {
  _UploadRest(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<UploadResponse> uploadServer(session) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'session': session};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<UploadResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
            .compose(
              _dio.options,
              '/upload/upload',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UploadResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UploadFinishResponse> upload(
    sess_id,
    upload_type,
    srv_id,
    to_json,
    file_1,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry(
      'sess_id',
      sess_id,
    ));
    _data.fields.add(MapEntry(
      'upload_type',
      upload_type,
    ));
    _data.fields.add(MapEntry(
      'srv_id',
      srv_id.toString(),
    ));
    _data.fields.add(MapEntry(
      'to_json',
      to_json.toString(),
    ));
    _data.fields.add(MapEntry(
      'file_1',
      file_1,
    ));
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<UploadFinishResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
            .compose(
              _dio.options,
              '/upload',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UploadFinishResponse.fromJson(_result.data!);
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
