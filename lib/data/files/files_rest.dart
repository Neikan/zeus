// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/utils/rest_accessor.dart';
import 'package:retrofit/retrofit.dart';

part 'files_rest.g.dart';

FilesRest retorfitFilesRest(Dio dio, {String? baseUrl}) =>
    _FilesRest(dio, baseUrl: baseUrl);

class ExtendedFilesRest extends ExtendedRest<FilesRest> {
  @override
  ExtendedFilesRest.baseUrls(Dio dio)
      : super.baseUrls(dio, restInterfaceGenerator: retorfitFilesRest);
}

@RestApi()
abstract class FilesRest {
  @POST("/files/my_files")
  @FormUrlEncoded()
  Future<FilesResponse> getFiles(@Field() String session, @Field() int fld_id,
      @Field() int page, @Field() int per_page);

  @POST("/folders/folder_create")
  @FormUrlEncoded()
  Future<CreateFolderResponse> createFolder(
      @Field() String session, @Field() String fld_name, @Field() int? fld_id);

  @POST("/folders/folder_edit")
  @FormUrlEncoded()
  Future<FolderResponse> renameFolder(
      @Field() String session, @Field() int fld_id, @Field() String fld_name);

  @POST("/folders/folder_delete")
  @FormUrlEncoded()
  Future<FolderResponse> deleteFolder(
      @Field() String session, @Field() String fld_id);

  @POST("/files/file_delete")
  @FormUrlEncoded()
  Future<FolderResponse> deleteFile(
      @Field() String session, @Field() String file_code);

  @POST("/files/file_edit")
  @FormUrlEncoded()
  Future<FolderResponse> renameFile(@Field() String session,
      @Field() String file_code, @Field() String file_name);

  @POST("/files/file_move")
  @FormUrlEncoded()
  Future<FolderResponse> moveFile(
      @Field() String session, @Field() String file_code, @Field() int fld_id);
}

@immutable
@JsonSerializable()
class FilesResponse {
  @JsonKey(name: "folders")
  final List<FolderObject> folders;
  @JsonKey(name: "files")
  final List<FileObject> files;
  @JsonKey(name: "pages")
  final int pages;

  const FilesResponse(
      {required this.folders, required this.files, required this.pages});

  factory FilesResponse.fromJson(Map<String, dynamic> json) =>
      _$FilesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FilesResponseToJson(this);
}

@immutable
@JsonSerializable()
class CreateFolderResponse {
  @JsonKey(name: "success")
  final int? success;
  @JsonKey(name: "error")
  final int? error;
  @JsonKey(name: "details")
  final String? details;
  @JsonKey(name: "fld_id")
  final String? folderId;

  const CreateFolderResponse(
      {this.success, this.error, this.details, this.folderId});

  factory CreateFolderResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateFolderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFolderResponseToJson(this);
}

@immutable
@JsonSerializable()
class FolderResponse {
  @JsonKey(name: "success")
  final int? success;
  @JsonKey(name: "error")
  final int? error;
  @JsonKey(name: "details")
  final String? details;

  const FolderResponse({this.success, this.error, this.details});

  factory FolderResponse.fromJson(Map<String, dynamic> json) =>
      _$FolderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FolderResponseToJson(this);
}

@immutable
@JsonSerializable()
class FileObject {
  @JsonKey(name: "file_code")
  final String? fileCode;
  @JsonKey(name: "short_code")
  final String? shortCode;
  @JsonKey(name: "file_name")
  final String name;
  @JsonKey(name: "file_size")
  final String size;
  @JsonKey(name: "created")
  final String created;

  String url(ServiceType serviceType) =>
      'https://${serviceType.domain}/$code/$name';

  DateTime get createdDateTime => DateTime.parse(created);

  String get code => fileCode ?? shortCode ?? '';

  const FileObject(
      {this.fileCode,
      this.shortCode,
      required this.name,
      required this.size,
      required this.created});

  factory FileObject.fromJson(Map<String, dynamic> json) =>
      _$FileObjectFromJson(json);

  Map<String, dynamic> toJson() => _$FileObjectToJson(this);
}

@immutable
@JsonSerializable()
class FolderObject {
  @JsonKey(name: "fld_id")
  final String id;
  @JsonKey(name: "fld_name")
  final String name;
  @JsonKey(name: "fld_files")
  final String files;

  int? get parentId => int.tryParse(id);

  const FolderObject(
      {required this.id, required this.name, required this.files});

  factory FolderObject.fromJson(Map<String, dynamic> json) =>
      _$FolderObjectFromJson(json);

  Map<String, dynamic> toJson() => _$FolderObjectToJson(this);
}
