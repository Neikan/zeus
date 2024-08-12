import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'constants.g.dart';

enum FlavorType { dev, prod }

const String flavor = String.fromEnvironment('app.flavor');

FlavorType flavorType =
    flavor == FlavorType.dev.name ? FlavorType.dev : FlavorType.prod;

const devServices = {
  ServiceType.filejoker: 'https://zeus.filejoker.net/app_api',
  ServiceType.novafile: 'https://zeus.filejoker.net/app_api',
};

const prodServices = {
  ServiceType.filejoker: 'https://filejoker.net/app_api',
  ServiceType.novafile: 'https://novafile.org/app_api',
};

const devDomains = {
  ServiceType.filejoker: 'zeus.filejoker.net',
  ServiceType.novafile: 'zeus.filejoker.net',
};

const prodDomains = {
  ServiceType.filejoker: 'filejoker.net',
  ServiceType.novafile: 'novafile.org',
};

const devBaseUrl = 'https://zeus.filejoker.net/app_api';

const prodBaseUrl = 'https://filejoker.net/app_api';

final baseUrl = flavorType == FlavorType.dev ? devBaseUrl : prodBaseUrl;

final services = flavorType == FlavorType.dev ? devServices : prodServices;

final domains = flavorType == FlavorType.dev ? devDomains : prodDomains;

const servicesSecureStorageKey = {
  ServiceType.filejoker: 'filejokerSecureStorage',
  ServiceType.novafile: 'novafileSecureStorage',
};

const servicesEmailSecureStorageKey = {
  ServiceType.filejoker: 'filejokerEmailSecureStorage',
  ServiceType.novafile: 'novafileEmailSecureStorage',
};

@HiveType(typeId: 2)
enum ServiceType {
  @HiveField(0)
  @JsonValue('filejoker')
  filejoker,
  @HiveField(1)
  @JsonValue('novafile')
  novafile,
}

ServiceType getServiceTypeByServiceUrl(String serviceUrl) {
  if (serviceUrl.startsWith(services[ServiceType.filejoker]!)) {
    return ServiceType.filejoker;
  }
  if (serviceUrl.startsWith(services[ServiceType.novafile]!)) {
    return ServiceType.novafile;
  }

  return ServiceType.filejoker;
}

extension StringExtension on String {
  String get capitalize =>
      '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
}

extension ServiceTypeExtension on ServiceType {
  String get service => services[this]!;

  String get domain => domains[this]!;

  String get secureStorageKey => servicesSecureStorageKey[this] ?? '';

  String get secureEmailStorageKey => servicesEmailSecureStorageKey[this] ?? '';

  String get nameRepresent => name.capitalize;
}

const sessionStorageKey = 'SESSION_KEY';
const currentServiceKye = 'CURRENT_SERVICE';

const Color mainBackColor = Color(0xFF050F67);
const Color accentColor = Color(0xFF24D7E3);
const Color lightOptionalColor = Color(0xFFECF7FF);
const Color extractorColor = Color(0xFF232D85);
const Color whiteBaseColor = Color(0xFFFFFFFF);
const Color optionalColor = Color(0xFF374199);
const Color lavenderColor = Color(0xFF727393);
const Color menuTextColor = Color(0xFFA1A2B4);
const Color deepBlueColor = Color(0xFF040C50);
const Color confirmationColor = Color(0xFF79D257);
const Color errorColor = Color(0xFFFF5652);
const Color azureColor = Color(0xFF146C9E);

const TextStyle h1Style = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w400,
  fontSize: 32,
  height: 1.2,
  color: whiteBaseColor,
);

const TextStyle h2SbStyle = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w600,
  fontSize: 16,
  height: 1.25,
  color: mainBackColor,
);

const TextStyle errorStyle = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w400,
  fontSize: 16,
  height: 1.25,
  color: errorColor,
);

const TextStyle novaStyle = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w600,
  fontSize: 17,
  height: 1.29,
  color: accentColor,
);

const TextStyle h2SbWhiteStyle = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w600,
  fontSize: 16,
  height: 1.25,
  color: whiteBaseColor,
);

const TextStyle h2SbAzureStyle = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w600,
  fontSize: 16,
  height: 1.25,
  color: azureColor,
);

const TextStyle h2RStyle = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w400,
  fontSize: 16,
  height: 1.25,
  color: accentColor,
);

const TextStyle h2RWhiteStyle = TextStyle(
    fontFamily: 'Raleway',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.25,
    color: whiteBaseColor);

const TextStyle h4Style = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w400,
  fontSize: 12,
  height: 1.33,
  color: lightOptionalColor,
);

const TextStyle h4AzureStyle = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w400,
  fontSize: 12,
  height: 1.33,
  color: azureColor,
);

const TextStyle h4MenuStyle = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w400,
  fontSize: 12,
  height: 1.33,
  color: menuTextColor,
);

const TextStyle h4AccentStyle = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w400,
  fontSize: 12,
  height: 1.33,
  color: accentColor,
);

const TextStyle h4ConfirmStyle = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w400,
  fontSize: 12,
  height: 1.33,
  color: confirmationColor,
);

const TextStyle h3RStyle = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w400,
  fontSize: 14,
  height: 1.29,
  color: whiteBaseColor,
);

const TextStyle h3SbStyle = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w400,
  fontSize: 14,
  height: 1.29,
  color: menuTextColor,
);

const TextStyle h3RAccentStyle = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w400,
  fontSize: 14,
  height: 1.29,
  color: accentColor,
);

const TextStyle menuStyle = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w400,
  fontSize: 10,
  height: 1.20,
  color: menuTextColor,
);

const TextStyle menuActiveStyle = TextStyle(
  fontFamily: 'Raleway',
  fontWeight: FontWeight.w400,
  fontSize: 10,
  height: 1.20,
  color: lightOptionalColor,
);
