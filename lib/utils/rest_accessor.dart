import 'package:dio/dio.dart';
import 'package:zeusfile/constants.dart';

abstract class ExtendedRest<RestInterface> {
  final RestInterface filejokerRest;
  final RestInterface novafileRest;

  ExtendedRest({required this.filejokerRest, required this.novafileRest});

  ExtendedRest.baseUrls(Dio dio,
      {required RestInterface Function(Dio dio, {required String baseUrl})
          restInterfaceGenerator})
      : filejokerRest =
            restInterfaceGenerator(dio, baseUrl: ServiceType.filejoker.service),
        novafileRest =
            restInterfaceGenerator(dio, baseUrl: ServiceType.novafile.service);

  RestInterface by(ServiceType serviceType) {
    switch (serviceType) {
      case ServiceType.filejoker:
        return filejokerRest;
      case ServiceType.novafile:
        return novafileRest;
    }
  }
}
