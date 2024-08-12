// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/auth/auth_rest.dart';
import 'package:zeusfile/presentation/authorization/bloc/auth_bloc.dart';
import 'package:zeusfile/presentation/widgets/popup_item.dart';

class AuthRepository {
  final ExtendedAuthRest extendedAuthRest;
  late FlutterSecureStorage flutterSecureStorage;

  Map<ServiceType, String?> serviceSessions = {
    ServiceType.filejoker: null,
    ServiceType.novafile: null
  };

  AuthRepository({required this.extendedAuthRest}) {
    flutterSecureStorage = const FlutterSecureStorage();
  }

  void setServiceSession(
          {required String? session, required ServiceType serviceType}) =>
      serviceSessions[serviceType] = session;

  String? getServiceSession({required ServiceType serviceType}) =>
      serviceSessions[serviceType];

  Future<ServiceAuth> getServiceAuthFromSecureStorage(
          {required ServiceType serviceType}) =>
      flutterSecureStorage
          .read(key: serviceType.secureStorageKey)
          .then((secureStorageRepresent) => secureStorageRepresent == null
              ? ServiceAuth.empty(serviceType: serviceType)
              : ServiceAuth.fromJson(jsonDecode(secureStorageRepresent)))
          .catchError((onError) => ServiceAuth.empty(serviceType: serviceType));

  Future<String?> getServiceEmailFromSecureStorage(
          {required ServiceType serviceType}) =>
      flutterSecureStorage
          .read(key: serviceType.secureEmailStorageKey)
          .then((email) => email)
          .catchError((onError) {
        print('READ ERROR: $onError');
      });

  Future<bool> writeServiceAuthToSecureStorage(
          {required ServiceAuth serviceAuth}) =>
      flutterSecureStorage
          .write(
              key: serviceAuth.serviceType.secureStorageKey,
              value: jsonEncode(serviceAuth.toJson()))
          .then((value) => true)
          .catchError((e) => false);

  Future<bool> writeEmailToSecureStorage(
          {required ServiceType serviceType, required String email}) =>
      flutterSecureStorage
          .write(key: serviceType.secureEmailStorageKey, value: email)
          .then((value) {
        return true;
      }).catchError((e) {
        return false;
      });

  Future<AuthResponse?> signIn(
      {required String email,
      required String password,
      required ServiceType serviceType}) async {
    try {
      final response =
          await extendedAuthRest.by(serviceType).auth(email, password);
      return response;
    } catch (e) {
      // TODO show error
      return null;
    }
  }

  Future<AccountResponse?> account(
      {required String session, required ServiceType serviceType}) async {
    try {
      final response = await extendedAuthRest.by(serviceType).account(session);

      return response;
    } catch (e) {
      // TODO show error
      print('ACCOUNT ERROR: $e');
      return null;
    }
  }

  Future<ChangePasswordResponse?> changePassword(
      {required String session,
      required String currentPassword,
      required String newPassword,
      required ServiceType service}) async {
    try {
      final response = await extendedAuthRest
          .by(service)
          .changePassword(session, currentPassword, newPassword);

      return response;
    } catch (e) {
      print('CHANGE PASSWORD ERROR: $e');
      return null;
    }
  }

  Future<ChangePasswordResponse?> restorePassword(
      {required String email, required ServiceType service}) async {
    try {
      final response =
          await extendedAuthRest.by(service).restorePassword(email);

      return response;
    } catch (e) {
      print('RESTORE PASSWORD ERROR: $e');
      return null;
    }
  }

  Future<ChangePasswordResponse?> checkPassword(
      {required String session,
      required String currentPassword,
      required ServiceType service}) async {
    try {
      final response = await extendedAuthRest
          .by(service)
          .checkPassword(session, currentPassword);

      return response;
    } catch (e) {
      print('CHECK PASSWORD ERROR: $e');
      return null;
    }
  }

  Future<bool> clearData({required ServiceType serviceType}) =>
      writeServiceAuthToSecureStorage(
          serviceAuth: ServiceAuth.empty(serviceType: serviceType));

  Future<void> promocode(
      {required String session,
      required String premiumKey,
      required ServiceType service}) async {
    try {
      final response =
          await extendedAuthRest.by(service).promocode(session, premiumKey);
      FToast().removeQueuedCustomToasts();
      FToast().showToast(
          gravity: ToastGravity.TOP,
          toastDuration: const Duration(seconds: 3),
          child: PopUpItem(
            text: response.details ?? '',
            onTap: () {
              FToast().removeQueuedCustomToasts();
            },
          ));
    } catch (e) {
      // TODO Show error
      // return null;
    }
  }

  Future<void> upgrade(
      {required String session,
      required ServiceType service,
      required PurchasedItem purchasedItem}) async {
    try {
      if (purchasedItem.productId == null) return;

      // ignore: unused_local_variable
      final response = await extendedAuthRest.by(service).upgrade(
            session,
            product_id: purchasedItem.productId!,
            receipt_data: purchasedItem.transactionReceipt,
            purchase_token: purchasedItem.purchaseToken,
          );
    } catch (e) {
      // TODO Show error
    }
  }

  Future<List<SubscriptionResponse>?> getSubscriptionResponseList(
      {required String session, required ServiceType service}) async {
    try {
      final response = await extendedAuthRest.by(service).getSubscriptions(
            session,
          );

      return response.subscriptions;
    } catch (e) {
      // TODO Show error
    }
    return null;
  }

  Future<bool?> logout(
      {required String session, required ServiceType serviceType}) async {
    try {
      // ignore: unused_local_variable
      final response = await extendedAuthRest.by(serviceType).logout(session);

      await clearData(serviceType: serviceType);

      return true;
    } catch (e) {
      // TODO show error
      return null;
    }
  }
}
