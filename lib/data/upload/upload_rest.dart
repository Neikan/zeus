// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zeusfile/utils/rest_accessor.dart';
import 'package:retrofit/retrofit.dart';

part 'upload_rest.g.dart';

UploadRest retorfitUploadRest(Dio dio, {String? baseUrl}) =>
    _UploadRest(dio, baseUrl: baseUrl);

class ExtendedUploadRest extends ExtendedRest<UploadRest> {
  @override
  ExtendedUploadRest.baseUrls(Dio dio)
      : super.baseUrls(dio, restInterfaceGenerator: retorfitUploadRest);
}

@RestApi()
abstract class UploadRest {
  @POST("/upload/upload")
  @FormUrlEncoded()
  Future<UploadResponse> uploadServer(@Field() String session);

  @POST("/upload")
  @MultiPart()
  Future<UploadFinishResponse> upload(
    @Part() String sess_id,
    @Part() String upload_type,
    @Part() int srv_id,
    @Part() int to_json,
    @Part() String file_1,
  );
}

@immutable
@JsonSerializable()
class UploadResponse {
  @JsonKey(name: "srv_id")
  final String srvId;
  @JsonKey(name: "url")
  final String url;

  const UploadResponse({required this.srvId, required this.url});

  factory UploadResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UploadResponseToJson(this);
}

@immutable
@JsonSerializable()
class UploadFinishResponse {
  @JsonKey(name: "result")
  final List<UploadInfoResponse> result;

  const UploadFinishResponse({required this.result});

  factory UploadFinishResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadFinishResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UploadFinishResponseToJson(this);
}

@immutable
@JsonSerializable()
class UploadInfoResponse {
  @JsonKey(name: "st")
  final String st;
  @JsonKey(name: "fn")
  final String fn;

  const UploadInfoResponse({required this.st, required this.fn});

  factory UploadInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UploadInfoResponseToJson(this);
}
