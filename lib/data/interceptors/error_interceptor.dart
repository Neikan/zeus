// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zeusfile/presentation/authorization/bloc/auth_bloc.dart';
import 'package:zeusfile/presentation/widgets/popup_item.dart';

class ErrorInterceptor extends Interceptor {
  GlobalKey<NavigatorState>? navigatorKey;
  BuildContext? globalContext;

  ErrorInterceptor();

  set navigator(GlobalKey<NavigatorState> navigator) {
    navigatorKey = navigator;
  }

  set context(BuildContext ctx) {
    globalContext = ctx;
  }

  @override
  void onError(DioError err, handler) {
    print('TYPE ERROR: ${err.type} ${err.response?.statusCode}');
    if (err.response?.statusCode == 401) {
      if (globalContext != null) {
        BlocProvider.of<AuthBloc>(globalContext!)
            .add(ClearDataEvent(serviceUrl: err.requestOptions.baseUrl));

        FToast().removeQueuedCustomToasts();
        FToast().showToast(
            gravity: ToastGravity.TOP,
            toastDuration: const Duration(seconds: 3),
            child: PopUpItem(
              text: 'Your session is expired',
              onTap: () {
                FToast().removeQueuedCustomToasts();
              },
            ));
      } else {
        FToast().removeQueuedCustomToasts();
        FToast().showToast(
            gravity: ToastGravity.TOP,
            toastDuration: const Duration(seconds: 3),
            child: PopUpItem(
              text: 'Your session is expired',
              onTap: () {
                FToast().removeQueuedCustomToasts();
              },
            ));
      }
    } else {
      if (err.response?.data?['details'] != null) {
        FToast().removeQueuedCustomToasts();
        FToast().showToast(
            gravity: ToastGravity.TOP,
            toastDuration: const Duration(seconds: 3),
            child: PopUpItem(
              text: err.response?.data?['details'] ?? 'Unknown error!',
              onTap: () {
                FToast().removeQueuedCustomToasts();
              },
            ));
      }
    }

    return handler.next(err);
  }
}

final dioErrorInterceptor = ErrorInterceptor();
