import 'package:dio/dio.dart';

class BaseUrlInterceptor extends Interceptor {
  String? _baseUrl;

  BaseUrlInterceptor();

  set baseUrl(String? url) {
    _baseUrl = url;
  }

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (_baseUrl != null) {
      handler.next(options.copyWith(baseUrl: _baseUrl));
    } else {
      handler.next(options);
    }
  }
}

final dioBaseUrlInterceptor = BaseUrlInterceptor();
