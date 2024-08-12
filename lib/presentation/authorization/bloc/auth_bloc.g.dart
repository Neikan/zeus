// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_bloc.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ServiceAuthCWProxy {
  ServiceAuth account(AccountResponse? account);

  ServiceAuth login(String? login);

  ServiceAuth serviceType(ServiceType serviceType);

  ServiceAuth session(String? session);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ServiceAuth(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ServiceAuth(...).copyWith(id: 12, name: "My name")
  /// ````
  ServiceAuth call({
    AccountResponse? account,
    String? login,
    ServiceType? serviceType,
    String? session,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfServiceAuth.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfServiceAuth.copyWith.fieldName(...)`
class _$ServiceAuthCWProxyImpl implements _$ServiceAuthCWProxy {
  final ServiceAuth _value;

  const _$ServiceAuthCWProxyImpl(this._value);

  @override
  ServiceAuth account(AccountResponse? account) => this(account: account);

  @override
  ServiceAuth login(String? login) => this(login: login);

  @override
  ServiceAuth serviceType(ServiceType serviceType) =>
      this(serviceType: serviceType);

  @override
  ServiceAuth session(String? session) => this(session: session);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ServiceAuth(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ServiceAuth(...).copyWith(id: 12, name: "My name")
  /// ````
  ServiceAuth call({
    Object? account = const $CopyWithPlaceholder(),
    Object? login = const $CopyWithPlaceholder(),
    Object? serviceType = const $CopyWithPlaceholder(),
    Object? session = const $CopyWithPlaceholder(),
  }) {
    return ServiceAuth(
      account: account == const $CopyWithPlaceholder()
          ? _value.account
          // ignore: cast_nullable_to_non_nullable
          : account as AccountResponse?,
      login: login == const $CopyWithPlaceholder()
          ? _value.login
          // ignore: cast_nullable_to_non_nullable
          : login as String?,
      serviceType:
          serviceType == const $CopyWithPlaceholder() || serviceType == null
              ? _value.serviceType
              // ignore: cast_nullable_to_non_nullable
              : serviceType as ServiceType,
      session: session == const $CopyWithPlaceholder()
          ? _value.session
          // ignore: cast_nullable_to_non_nullable
          : session as String?,
    );
  }
}

extension $ServiceAuthCopyWith on ServiceAuth {
  /// Returns a callable class that can be used as follows: `instanceOfServiceAuth.copyWith(...)` or like so:`instanceOfServiceAuth.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ServiceAuthCWProxy get copyWith => _$ServiceAuthCWProxyImpl(this);
}

abstract class _$CheckedAuthStateCWProxy {
  CheckedAuthState filejokerServiceAuth(ServiceAuth? filejokerServiceAuth);

  CheckedAuthState novafileServiceAuth(ServiceAuth? novafileServiceAuth);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CheckedAuthState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CheckedAuthState(...).copyWith(id: 12, name: "My name")
  /// ````
  CheckedAuthState call({
    ServiceAuth? filejokerServiceAuth,
    ServiceAuth? novafileServiceAuth,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCheckedAuthState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCheckedAuthState.copyWith.fieldName(...)`
class _$CheckedAuthStateCWProxyImpl implements _$CheckedAuthStateCWProxy {
  final CheckedAuthState _value;

  const _$CheckedAuthStateCWProxyImpl(this._value);

  @override
  CheckedAuthState filejokerServiceAuth(ServiceAuth? filejokerServiceAuth) =>
      this(filejokerServiceAuth: filejokerServiceAuth);

  @override
  CheckedAuthState novafileServiceAuth(ServiceAuth? novafileServiceAuth) =>
      this(novafileServiceAuth: novafileServiceAuth);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CheckedAuthState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CheckedAuthState(...).copyWith(id: 12, name: "My name")
  /// ````
  CheckedAuthState call({
    Object? filejokerServiceAuth = const $CopyWithPlaceholder(),
    Object? novafileServiceAuth = const $CopyWithPlaceholder(),
  }) {
    return CheckedAuthState(
      filejokerServiceAuth: filejokerServiceAuth == const $CopyWithPlaceholder()
          ? _value.filejokerServiceAuth
          // ignore: cast_nullable_to_non_nullable
          : filejokerServiceAuth as ServiceAuth?,
      novafileServiceAuth: novafileServiceAuth == const $CopyWithPlaceholder()
          ? _value.novafileServiceAuth
          // ignore: cast_nullable_to_non_nullable
          : novafileServiceAuth as ServiceAuth?,
    );
  }
}

extension $CheckedAuthStateCopyWith on CheckedAuthState {
  /// Returns a callable class that can be used as follows: `instanceOfCheckedAuthState.copyWith(...)` or like so:`instanceOfCheckedAuthState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CheckedAuthStateCWProxy get copyWith => _$CheckedAuthStateCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceAuth _$ServiceAuthFromJson(Map<String, dynamic> json) => ServiceAuth(
      account: json['account'] == null
          ? null
          : AccountResponse.fromJson(json['account'] as Map<String, dynamic>),
      login: json['login'] as String?,
      session: json['session'] as String?,
      serviceType: $enumDecode(_$ServiceTypeEnumMap, json['serviceType']),
    );

Map<String, dynamic> _$ServiceAuthToJson(ServiceAuth instance) =>
    <String, dynamic>{
      'account': instance.account,
      'login': instance.login,
      'session': instance.session,
      'serviceType': _$ServiceTypeEnumMap[instance.serviceType]!,
    };

const _$ServiceTypeEnumMap = {
  ServiceType.filejoker: 'filejoker',
  ServiceType.novafile: 'novafile',
};
