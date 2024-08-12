// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zeusfile/utils/rest_accessor.dart';
import 'package:retrofit/retrofit.dart';

part 'download_rest.g.dart';

DownloadRest retorfitDownloadRest(Dio dio, {String? baseUrl}) =>
    _DownloadRest(dio, baseUrl: baseUrl);

class ExtendedDownloadRest extends ExtendedRest<DownloadRest> {
  @override
  ExtendedDownloadRest.baseUrls(Dio dio)
      : super.baseUrls(dio, restInterfaceGenerator: retorfitDownloadRest);
}

@RestApi()
abstract class DownloadRest {
  @POST("/download/download1")
  @FormUrlEncoded()
  Future<DownloadServerResponse> downloadServer(
      @Field() String session, @Field() String file_code);

  @POST("/download/download2")
  @FormUrlEncoded()
  Future<DownloadLinkResponse> downloadLink(@Field() String session,
      @Field() String file_code, @Field() String download_id);
}

@immutable
@JsonSerializable()
class DownloadServerResponse {
  @JsonKey(name: "download_id")
  final String? downloadId;
  @JsonKey(name: "file_size")
  final String? fileSize;
  @JsonKey(name: "file_name")
  final String? fileName;
  @JsonKey(name: "file_code")
  final String? fileCode;
  @JsonKey(name: "countdown")
  final String? countdown;
  @JsonKey(name: "error")
  final int? error;
  @JsonKey(name: "details")
  final String? details;

  const DownloadServerResponse(
      {this.downloadId,
      this.fileSize,
      this.fileName,
      this.fileCode,
      this.countdown,
      this.error,
      this.details});

  factory DownloadServerResponse.fromJson(Map<String, dynamic> json) =>
      _$DownloadServerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DownloadServerResponseToJson(this);
}

@immutable
@JsonSerializable()
class DownloadLinkResponse {
  @JsonKey(name: "direct_link")
  final String? link;
  @JsonKey(name: "file_size")
  final String? fileSize;
  @JsonKey(name: "file_name")
  final String? fileName;
  @JsonKey(name: "file_code")
  final String? fileCode;
  @JsonKey(name: "error")
  final int? error;
  @JsonKey(name: "details")
  final String? details;

  const DownloadLinkResponse(
      {this.link,
      this.fileSize,
      this.fileName,
      this.fileCode,
      this.error,
      this.details});

  factory DownloadLinkResponse.fromJson(Map<String, dynamic> json) =>
      _$DownloadLinkResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DownloadLinkResponseToJson(this);
}
