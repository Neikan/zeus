part of 'auth_bloc.dart';

@JsonSerializable()
@CopyWith()
@immutable
class ServiceAuth extends Equatable {
  final AccountResponse? account;

  @JsonKey(name: 'login')
  final String? login;
  @JsonKey(name: 'session')
  final String? session;
  @JsonKey(name: 'serviceType')
  final ServiceType serviceType;

  bool get authorized => session != null;

  const ServiceAuth(
      {required this.account,
      required this.login,
      required this.session,
      required this.serviceType});

  const ServiceAuth.empty({required this.serviceType})
      : account = null,
        login = null,
        session = null;

  const ServiceAuth.filejoker()
      : account = null,
        login = null,
        session = null,
        serviceType = ServiceType.filejoker;

  const ServiceAuth.novafile()
      : account = null,
        login = null,
        session = null,
        serviceType = ServiceType.novafile;

  @override
  List<Object?> get props => [account, login, session, serviceType];

  factory ServiceAuth.fromJson(Map<String, dynamic> json) =>
      _$ServiceAuthFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceAuthToJson(this);
}

class AuthState extends Equatable {
  final ServiceAuth filejokerServiceAuth;
  final ServiceAuth novafileServiceAuth;

  const AuthState({
    required this.filejokerServiceAuth,
    required this.novafileServiceAuth,
  });

  NetworkStatus get networkStatus => NetworkStatus.initial;

  ServiceAuth getServiceAuth({required ServiceType serviceType}) {
    switch (serviceType) {
      case ServiceType.filejoker:
        return filejokerServiceAuth;
      case ServiceType.novafile:
        return novafileServiceAuth;
    }
  }

  int get authorizedCount =>
      (filejokerServiceAuth.authorized ? 1 : 0) +
      (novafileServiceAuth.authorized ? 1 : 0);

  @override
  List<Object?> get props => [filejokerServiceAuth, novafileServiceAuth];
}

class InitialAuthState extends AuthState {
  const InitialAuthState()
      : super(
            filejokerServiceAuth: const ServiceAuth.filejoker(),
            novafileServiceAuth: const ServiceAuth.novafile());
}

@CopyWith()
class CheckedAuthState extends AuthState {
  const CheckedAuthState(
      {ServiceAuth? filejokerServiceAuth, ServiceAuth? novafileServiceAuth})
      : super(
            filejokerServiceAuth:
                filejokerServiceAuth ?? const ServiceAuth.filejoker(),
            novafileServiceAuth:
                novafileServiceAuth ?? const ServiceAuth.novafile());

  bool get filejokerAuthorized => filejokerServiceAuth.authorized;
  bool get novafileAuthorized => novafileServiceAuth.authorized;

  bool get authorized => filejokerAuthorized || novafileAuthorized;
}
