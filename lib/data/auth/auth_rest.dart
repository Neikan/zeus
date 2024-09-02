// ignore_for_file: non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zeusfile/utils/rest_accessor.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_rest.g.dart';

AuthRest retorfitAuthRest(Dio dio, {String? baseUrl}) =>
    _AuthRest(dio, baseUrl: baseUrl);

class ExtendedAuthRest extends ExtendedRest<AuthRest> {
  @override
  ExtendedAuthRest.baseUrls(Dio dio)
      : super.baseUrls(dio, restInterfaceGenerator: retorfitAuthRest);
}

@RestApi()
abstract class AuthRest {
  @POST("/auth/login")
  @FormUrlEncoded()
  Future<AuthResponse> auth(@Field() String email, @Field() String password);

  @POST("/account/my_account")
  @FormUrlEncoded()
  Future<AccountResponse> account(@Field() String session);

  @POST("/account/change_password")
  @FormUrlEncoded()
  Future<ChangePasswordResponse> changePassword(@Field() String session,
      @Field() String password_current, @Field() String password_new);

  @POST("/account/restore_password")
  @FormUrlEncoded()
  Future<ChangePasswordResponse> restorePassword(@Field() String user_email);

  @POST("/account/check_password")
  @FormUrlEncoded()
  Future<ChangePasswordResponse> checkPassword(
      @Field() String session, @Field() String password_current);

  @POST("/auth/logout")
  @FormUrlEncoded()
  Future<void> logout(@Field() String session);

  @POST("/account/use_premium_key")
  @FormUrlEncoded()
  Future<ChangePasswordResponse> promocode(
      @Field() String session, @Field() String premium_key);

  @POST("/account/upgrade")
  @FormUrlEncoded()
  Future<ChangePasswordResponse> upgrade(@Field() String session,
      {@Field() required String product_id,
      @Field() String? purchase_token,
      @Field() String? receipt_data});

  @POST("/account/subscriptions")
  @FormUrlEncoded()
  Future<SubscriptionsResponse> getSubscriptions(
    @Field() String session,
  );
}

@immutable
@JsonSerializable()
class SubscriptionsResponse {
  @JsonKey(name: "subscriptions")
  final List<SubscriptionResponse> subscriptions;

  const SubscriptionsResponse({
    required this.subscriptions,
  });

  factory SubscriptionsResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionsResponseToJson(this);
}

@immutable
@JsonSerializable()
class SubscriptionResponse {
  @JsonKey(name: "product_id")
  final String productId;

  @JsonKey(name: "active")
  final int isActiveInt;

  @JsonKey(name: "expire_at", includeIfNull: true)
  final String? expireAt;

  const SubscriptionResponse(
      {required this.productId,
      required this.isActiveInt,
      required this.expireAt});

  bool get isActive => isActiveInt == 1;

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionResponseToJson(this);
}

@immutable
@JsonSerializable()
class AuthResponse {
  @JsonKey(name: "session")
  final String session;

  const AuthResponse({required this.session});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  bool get isSuccess => session.isNotEmpty;

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

@immutable
@JsonSerializable()
class ChangePasswordResponse {
  @JsonKey(name: "success")
  final int? success;
  @JsonKey(name: "error")
  final int? error;
  @JsonKey(name: "details")
  final String? details;
  @JsonKey(name: "message")
  final String? message;

  const ChangePasswordResponse(
      {this.success, this.error, this.details, this.message});

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordResponseToJson(this);
}

@immutable
@JsonSerializable()
class AccountResponse {
  @JsonKey(name: "usr_login")
  final String login;
  @JsonKey(name: "usr_email")
  final String email;
  @JsonKey(name: "traffic_left")
  final String? traffic;
  @JsonKey(name: "server_time")
  final String? serverTime;
  @JsonKey(name: "usr_premium_expire")
  final String? premiumExpire;
  @JsonKey(name: "usr_allowed_ips")
  final String? allowedIps;
  @JsonKey(name: "usr_pay_type")
  final String? payType;
  @JsonKey(name: "usr_email_paypal")
  final String? paypalEmail;

  const AccountResponse({
    required this.login,
    this.allowedIps,
    required this.email,
    this.payType,
    this.paypalEmail,
    this.premiumExpire,
    this.serverTime,
    this.traffic,
  });

  bool get hasPremium =>
      premiumExpiresDateTime != null &&
      DateTime.now().isBefore(premiumExpiresDateTime!);

  DateTime? get premiumExpiresDateTime =>
      premiumExpire == null ? null : DateTime.parse(premiumExpire!);

  factory AccountResponse.fromJson(Map<String, dynamic> json) =>
      _$AccountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AccountResponseToJson(this);
}
