// ignore_for_file: unused_catch_stack, unused_local_variable

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/auth/auth_rest.dart';
import 'package:zeusfile/data/statuses_cubit/network_status_cubit.dart';
import 'package:zeusfile/presentation/widgets/popup_item.dart';
import 'package:zeusfile/repository/auth_repository.dart';
import 'package:zeusfile/utils/enums.dart';
import 'package:synchronized/synchronized.dart';

part 'auth_state.dart';
part 'auth_event.dart';
part 'auth_bloc.g.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final NetworkStatusCubit networkStatusCubit;

  final lock = Lock();

  AuthBloc({required this.authRepository, required this.networkStatusCubit})
      : super(const InitialAuthState()) {
    on<LoginEvent>(_mapLoginEventToState);
    on<ApplySessionEvent>(_mapApplySessionEventToState);
    on<LoadSessionsEvent>(_mapLoadSessionsEventToState);
    on<LogoutEvent>(_mapLogoutEventToState);
    on<LoadAccountEvent>(_mapAccountEventToState);

    on<ClearDataEvent>(_mapClearDataEventToState);
    on<SetPassword>(_mapSetPasswordEventToState);
    on<ChangePassword>(_mapChangePasswordEventToState);

    on<Promocode>(_mapPromocodeEventToState);

    add(const LoadSessionsEvent());
  }

  void _mapLoginEventToState(LoginEvent event, Emitter<AuthState> emit) async {
    networkStatusCubit.loading();
    try {
      final result = await authRepository.signIn(
          email: event.email,
          password: event.password,
          serviceType: event.serviceType);

      if (!(result?.isSuccess ?? false)) {
        return;
      }

      authRepository.writeEmailToSecureStorage(
          serviceType: event.serviceType, email: event.email);

      final resultAccount = await authRepository.account(
          session: result!.session, serviceType: event.serviceType);

      if (resultAccount == null) {
        return;
      }

      CheckedAuthState currentState = state is InitialAuthState
          ? const CheckedAuthState()
          : state as CheckedAuthState;

      final ServiceAuth serviceAuth = ServiceAuth(
          account: resultAccount,
          login: resultAccount.login,
          session: result.session,
          serviceType: event.serviceType);

      add(ApplySessionEvent(
          serviceAuth: serviceAuth, serviceType: event.serviceType));
    } catch (e, stacktrace) {
      // TODO show error message
    } finally {
      networkStatusCubit.success();
    }
  }

  FutureOr<void> _mapApplySessionEventToState(
      ApplySessionEvent event, Emitter<AuthState> emit) {
    lock.synchronized(() {
      CheckedAuthState currentState = state is InitialAuthState
          ? const CheckedAuthState()
          : state as CheckedAuthState;

      switch (event.serviceType) {
        case ServiceType.filejoker:
          currentState =
              currentState.copyWith(filejokerServiceAuth: event.serviceAuth);
          break;
        case ServiceType.novafile:
          currentState =
              currentState.copyWith(novafileServiceAuth: event.serviceAuth);
          break;
      }

      authRepository.writeServiceAuthToSecureStorage(
          serviceAuth: event.serviceAuth);

      authRepository.setServiceSession(
          session: event.serviceAuth.session, serviceType: event.serviceType);

      emit(currentState);
    });
  }

  Future<String?> getEmailFromStorage(ServiceType serviceType) async {
    return await authRepository.getServiceEmailFromSecureStorage(
        serviceType: serviceType);
  }

  FutureOr<void> _mapLoadSessionsEventToState(
      LoadSessionsEvent event, Emitter<AuthState> emit) async {
    final filejokerServiceAuth = await authRepository
        .getServiceAuthFromSecureStorage(serviceType: ServiceType.filejoker);

    final novafileServiceAuth = await authRepository
        .getServiceAuthFromSecureStorage(serviceType: ServiceType.novafile);

    add(ApplySessionEvent(
        serviceAuth: filejokerServiceAuth, serviceType: ServiceType.filejoker));
    add(ApplySessionEvent(
        serviceAuth: novafileServiceAuth, serviceType: ServiceType.novafile));
  }

  void _mapLogoutEventToState(
      LogoutEvent event, Emitter<AuthState> emit) async {
    networkStatusCubit.loading();

    add(ApplySessionEvent(
        serviceAuth: ServiceAuth.empty(serviceType: event.serviceType),
        serviceType: event.serviceType));

    try {
      final result = await authRepository.logout(
          session: event.session, serviceType: event.serviceType);
    } catch (e) {
      // TODO show error
    }

    networkStatusCubit.success();
  }

  void _mapAccountEventToState(
      LoadAccountEvent event, Emitter<AuthState> emit) async {
    networkStatusCubit.loading();
    lock.synchronized(() async {
      try {
        final account = await authRepository.account(
            session: event.session, serviceType: event.serviceType);

        ServiceAuth serviceAuth;

        switch (event.serviceType) {
          case ServiceType.filejoker:
            serviceAuth = state.filejokerServiceAuth;
            break;
          case ServiceType.novafile:
            serviceAuth = state.novafileServiceAuth;
            break;
        }

        add(ApplySessionEvent(
            serviceAuth: serviceAuth.copyWith(account: account),
            serviceType: event.serviceType));
      } catch (e, stacktrace) {
        // TODO show error message
      } finally {
        networkStatusCubit.success();
      }
    });
  }

  void _mapClearDataEventToState(
      ClearDataEvent event, Emitter<AuthState> emit) {
    add(ApplySessionEvent(
        serviceAuth: ServiceAuth.empty(serviceType: event.serviceType),
        serviceType: event.serviceType));
  }

  Future<bool> checkPassword(CheckPassword event) async {
    networkStatusCubit.loading();
    try {
      final result = await authRepository.checkPassword(
        session:
            state.getServiceAuth(serviceType: event.serviceType).session ?? '',
        service: event.serviceType,
        currentPassword: event.currentPassword,
      );

      if (result?.success == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e, stacktrace) {
      // TODO log error message
      return false;
    } finally {
      networkStatusCubit.success();
    }
  }

  Future<bool> changePassword(ChangePassword event) async {
    networkStatusCubit.loading();
    try {
      final result = await authRepository.changePassword(
          session:
              state.getServiceAuth(serviceType: event.serviceType).session ??
                  '',
          service: event.serviceType,
          currentPassword: event.currentPassword,
          newPassword: event.newPassword);

      if (result?.success == 1) {
        return true;
      } else {
        return false;
      }
    } catch (e, stacktrace) {
      // TODO log error message
      return false;
    } finally {
      networkStatusCubit.success();
    }
  }

  Future<bool> restorePassword(RestorePassword event) async {
    networkStatusCubit.loading();
    try {
      final result = await authRepository.restorePassword(
          service: event.serviceType, email: event.email);

      if (result?.success == 1) {
        FToast().removeQueuedCustomToasts();
        FToast().showToast(
            gravity: ToastGravity.TOP,
            toastDuration: const Duration(seconds: 3),
            child: PopUpItem(
              text: result?.details ??
                  'Your Login & Password have been sent to your Email',
              onTap: () {
                FToast().removeQueuedCustomToasts();
              },
              textStyle: h2SbStyle,
            ));
        return true;
      } else {
        return false;
      }
    } catch (e, stacktrace) {
      // TODO log error message
      return false;
    } finally {
      networkStatusCubit.success();
    }
  }

  void _mapChangePasswordEventToState(
      ChangePassword event, Emitter<AuthState> emit) async {}

// --------------
  void _mapSetPasswordEventToState(
      SetPassword event, Emitter<AuthState> emit) async {
    // TODO add set password logic
    // if (state.checkedPassword != true) {
    //   final result = await authRepository.checkPassword(
    //       state.session!, event.currentPass!);
    //   if (result?.success == 1) {
    //     emit(state.copyWith(
    //         status: NetworkStatus.initial,
    //         passwordChanged: false,
    //         currentPassword: event.currentPass,
    //         checkedPassword: true,
    //         newPassword: event.newPass));
    //   } else {
    //     emit(state.copyWith(
    //         status: NetworkStatus.error,
    //         passwordChanged: false,
    //         currentPassword: event.currentPass,
    //         checkedPassword: false,
    //         newPassword: event.newPass));
    //   }
    // } else {
    //   emit(state.copyWith(
    //       status: NetworkStatus.initial,
    //       passwordChanged: false,
    //       currentPassword: event.currentPass,
    //       checkedPassword: false,
    //       newPassword: event.newPass));
    // }
  }

  void _mapPromocodeEventToState(
      Promocode event, Emitter<AuthState> emit) async {
    // TODO promocode logic
    // emit(state.copyWith(status: NetworkStatus.loading));
    // try {
    //   await authRepository.promocode(event.session, event.premiumKey);
    //   emit(state.copyWith(status: NetworkStatus.success));
    // } catch (e, stacktrace) {
    //   emit(state.copyWith(status: NetworkStatus.error));
    // }
  }
}
