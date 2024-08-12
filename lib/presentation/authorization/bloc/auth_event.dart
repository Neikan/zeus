part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  final ServiceType serviceType;

  const AuthEvent({required this.serviceType});

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent(
      {required this.email,
      required this.password,
      required super.serviceType});

  @override
  List<Object?> get props => [email, password, serviceType];
}

class ApplySessionEvent extends AuthEvent {
  final ServiceAuth serviceAuth;

  const ApplySessionEvent(
      {required this.serviceAuth, required super.serviceType});

  @override
  List<Object?> get props => [serviceAuth, serviceType];
}

class LoadSessionsEvent extends AuthEvent {
  const LoadSessionsEvent({super.serviceType = ServiceType.filejoker});
}

class CheckPassword extends AuthEvent {
  final String session;
  final String currentPassword;

  const CheckPassword(
      {required this.currentPassword,
      required super.serviceType,
      required this.session});

  @override
  List<Object?> get props => [];
}

class ChangePassword extends AuthEvent {
  final String session;
  final String currentPassword;
  final String newPassword;

  const ChangePassword(
      {required this.currentPassword,
      required this.newPassword,
      required super.serviceType,
      required this.session});

  @override
  List<Object?> get props => [];
}

class RestorePassword extends AuthEvent {
  final String email;

  const RestorePassword({required this.email, required super.serviceType});

  @override
  List<Object?> get props => [email];
}

class Register extends AuthEvent {
  const Register({required super.serviceType});
}

class LoadAccountEvent extends AuthEvent {
  final String session;

  const LoadAccountEvent({required this.session, required super.serviceType});

  @override
  List<Object?> get props => [session];
}

class SetPassword extends AuthEvent {
  final String? currentPass;
  final String? newPass;

  const SetPassword(
      {this.currentPass, this.newPass, required super.serviceType});

  @override
  List<Object?> get props => [currentPass, newPass];
}

class LogoutEvent extends AuthEvent {
  final String session;

  const LogoutEvent({required this.session, required super.serviceType});

  @override
  List<Object?> get props => [session, serviceType];
}

class Promocode extends AuthEvent {
  final String session;
  final String premiumKey;

  const Promocode(
      {required this.session,
      required this.premiumKey,
      required super.serviceType});

  @override
  List<Object?> get props => [session, premiumKey];
}

class ClearDataEvent extends AuthEvent {
  ClearDataEvent({required String serviceUrl})
      : super(serviceType: getServiceTypeByServiceUrl(serviceUrl));

  @override
  List<Object?> get props => [serviceType];
}
