import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_logger/dio_logger.dart';
import 'package:zeusfile/data/interceptors/error_interceptor.dart';

Dio? _dio;

Dio dioInstance() {
  if (_dio == null) {
    BaseOptions options = BaseOptions(
        // connectTimeout: 15000,
        // receiveTimeout: 6000,
        );
    _dio = Dio(options);

    (_dio?.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
      return null;
    };

    _dio!.interceptors.add(dioLoggerInterceptor);
    _dio!.interceptors.add(dioErrorInterceptor);
  }

  return _dio!;
}
