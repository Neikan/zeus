import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:zeusfile/constants.dart';

enum SubscriptionType { premium, vip }

extension SubscriptionTypeExtenison on SubscriptionType {
  String get represent {
    switch (this) {
      case SubscriptionType.premium:
        return 'Premium';
      case SubscriptionType.vip:
        return 'Premium VIP';
    }
  }
}

enum SubscriptionElement {
  // Premium services
  premium365,
  premium180,
  premium90,
  premium30,
  // Premium vip services
  premiumVip365,
  premiumVip180,
  premiumVip90,
  premiumVip30,
}

extension SubscriptionElementExtenison on SubscriptionElement {
  double get defaultPriceFilejoker {
    switch (this) {
      case SubscriptionElement.premium365:
        return 134.99;
      case SubscriptionElement.premium180:
        return 89.99;
      case SubscriptionElement.premium90:
        return 44.95;
      case SubscriptionElement.premium30:
        return 22.95;
      case SubscriptionElement.premiumVip365:
        return 172.99;
      case SubscriptionElement.premiumVip180:
        return 112.99;
      case SubscriptionElement.premiumVip90:
        return 76.99;
      case SubscriptionElement.premiumVip30:
        return 36.95;
    }
  }

  double get defaultPriceNovafile {
    switch (this) {
      case SubscriptionElement.premium365:
        return 99.99;
      case SubscriptionElement.premium180:
        return 94.99;
      case SubscriptionElement.premium90:
        return 59.99;
      case SubscriptionElement.premium30:
        return 29.95;
      case SubscriptionElement.premiumVip365:
        return 129.99;
      case SubscriptionElement.premiumVip180:
        return 94.99;
      case SubscriptionElement.premiumVip90:
        return 59.99;
      case SubscriptionElement.premiumVip30:
        return 29.95;
    }
  }

  String get subscriptionTypeName {
    switch (this) {
      case SubscriptionElement.premium365:
        return 'PREMIUM_365';
      case SubscriptionElement.premium180:
        return 'PREMIUM_180';
      case SubscriptionElement.premium90:
        return 'PREMIUM_90';
      case SubscriptionElement.premium30:
        return 'PREMIUM_30';
      case SubscriptionElement.premiumVip365:
        return 'PREMIUM_VIP_365';
      case SubscriptionElement.premiumVip180:
        return 'PREMIUM_VIP_180';
      case SubscriptionElement.premiumVip90:
        return 'PREMIUM_VIP_90';
      case SubscriptionElement.premiumVip30:
        return 'PREMIUM_VIP_30';
    }
  }

  int get days {
    switch (this) {
      case SubscriptionElement.premium365:
        return 365;
      case SubscriptionElement.premium180:
        return 180;
      case SubscriptionElement.premium90:
        return 90;
      case SubscriptionElement.premium30:
        return 30;
      case SubscriptionElement.premiumVip365:
        return 365;
      case SubscriptionElement.premiumVip180:
        return 180;
      case SubscriptionElement.premiumVip90:
        return 90;
      case SubscriptionElement.premiumVip30:
        return 30;
    }
  }

  SubscriptionType get subscriptionType {
    switch (this) {
      case SubscriptionElement.premium365:
        return SubscriptionType.premium;
      case SubscriptionElement.premium180:
        return SubscriptionType.premium;
      case SubscriptionElement.premium90:
        return SubscriptionType.premium;
      case SubscriptionElement.premium30:
        return SubscriptionType.premium;
      case SubscriptionElement.premiumVip365:
        return SubscriptionType.vip;
      case SubscriptionElement.premiumVip180:
        return SubscriptionType.vip;
      case SubscriptionElement.premiumVip90:
        return SubscriptionType.vip;
      case SubscriptionElement.premiumVip30:
        return SubscriptionType.vip;
    }
  }

  String getPurchaseElementName({required ServiceType serviceType}) =>
      '${serviceType.nameRepresent}_$subscriptionTypeName';

  String getProductId({required ServiceType serviceType}) => Platform.isIOS
      ? getPurchaseElementName(serviceType: serviceType).toLowerCase()
      : getPurchaseElementName(serviceType: serviceType).toLowerCase();
}

@immutable
class PurchaseElement extends Equatable {
  final SubscriptionElement subscriptionElement;
  final ServiceType serviceType;
  final IAPItem? currentIAPItem;

  static List<IAPItem> listIAPI = [];

  PurchaseElement({
    required this.subscriptionElement,
    required this.serviceType,
    IAPItem? currentIAPItem,
  }) : currentIAPItem = currentIAPItem ??
            getIAPI(
              listIAPI: listIAPI,
              productId: subscriptionElement.getProductId(serviceType: serviceType),
            );

  String get purchaseElementName =>
      subscriptionElement.getPurchaseElementName(serviceType: serviceType);

  String get productId => subscriptionElement.getProductId(serviceType: serviceType);

  double get defaultPrice => serviceType == ServiceType.filejoker
      ? subscriptionElement.defaultPriceFilejoker
      : subscriptionElement.defaultPriceNovafile;

  String get price => currentIAPItem?.price ?? defaultPrice.toStringAsFixed(2);

  static IAPItem? getIAPI({
    required List<IAPItem> listIAPI,
    required String productId,
  }) =>
      listIAPI.where((element) => element.productId == productId).isEmpty
          ? null
          : listIAPI.firstWhere((element) => element.productId == productId);

  static List<PurchaseElement> get novafilePurchaseElements => SubscriptionElement.values
      .map((subscriptionElement) => PurchaseElement(
          serviceType: ServiceType.novafile,
          subscriptionElement: subscriptionElement,
          currentIAPItem: null))
      .toList();

  static List<PurchaseElement> get filejokerPurchaseElements => SubscriptionElement.values
      .map((subscriptionType) => PurchaseElement(
          serviceType: ServiceType.filejoker, subscriptionElement: subscriptionType))
      .toList();

  static List<PurchaseElement> get allPurchaseElements =>
      [...novafilePurchaseElements, ...filejokerPurchaseElements];

  static List<PurchaseElement> getServicePurchaseElementList({
    required ServiceType serviceType,
  }) =>
      serviceType == ServiceType.filejoker ? filejokerPurchaseElements : novafilePurchaseElements;

  static List<PurchaseElement> getPurchaseElemetList({
    required ServiceType serviceType,
    required SubscriptionType subscriptionType,
  }) =>
      getServicePurchaseElementList(serviceType: serviceType)
          .where((element) => element.subscriptionElement.subscriptionType == subscriptionType)
          .toList();

  @override
  List<Object?> get props => [serviceType, subscriptionElement, currentIAPItem];
}

extension ListPurchaseElement on List<PurchaseElement> {
  List<String> get productIds => map((purchaseElement) => purchaseElement.productId).toList();

  PurchaseElement? getPurchaseElement({required String productId}) => any(
        (element) => element.productId == productId,
      )
          ? firstWhere((element) => element.productId == productId)
          : null;

  List<PurchaseElement> getPurchasedElements({required List<PurchasedItem> listIAPI}) =>
      where((purchaseElement) =>
          listIAPI.any((iapiItem) => iapiItem.productId == purchaseElement.productId)).toList();
}

class PurchaseService {
  StreamSubscription? purchaseUpdatedSubscription;
  StreamSubscription? purchaseErrorSubscription;
  StreamSubscription? conectionSubscription;

  List<IAPItem> _products = [];

  List<IAPItem> get products => _products;

  List<PurchasedItem> _pastPurchases = [];

  Future<void> init({
    void Function(PurchasedItem? purchasedItem)? purchaseCallback,
  }) async {
    purchaseUpdatedSubscription?.cancel();
    purchaseErrorSubscription?.cancel();

    await FlutterInappPurchase.instance.initialize();

    purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen(purchaseCallback);

    purchaseErrorSubscription = FlutterInappPurchase.purchaseError.listen((error) {
      debugPrint('error $error');
    });
  }

  void dispose() {
    purchaseUpdatedSubscription?.cancel();
    purchaseErrorSubscription?.cancel();
    FlutterInappPurchase.instance.finalize();
  }

  Future<List<IAPItem>> getSubscriptions() => FlutterInappPurchase.instance
      .getSubscriptions(PurchaseElement.allPurchaseElements.productIds);

  Future _getPastPurchases() async {
    if (Platform.isIOS) {
      return;
    }

    List<PurchasedItem> purchasedItems =
        await FlutterInappPurchase.instance.getAvailablePurchases() ?? [];

    for (var purchasedItem in purchasedItems) {
      bool isValid = false;

      if (Platform.isAndroid) {
        Map map = jsonDecode(purchasedItem.transactionReceipt!);

        if (!map['acknowledged']) {
          isValid = await _verifyPurchase(item: purchasedItem);
          if (isValid) {
            FlutterInappPurchase.instance.finishTransaction(purchasedItem);
          }
        } else {}
      }
    }

    _pastPurchases.addAll(purchasedItems);
  }

  Future<List<PurchasedItem>> checkForSubscriptions() async {
    if (Platform.isIOS) {
      final purchaseHistory = await FlutterInappPurchase.instance.getAvailablePurchases();

      final purchases = <PurchasedItem>[];

      for (var purchase in purchaseHistory ?? <PurchasedItem>[]) {
        if (purchase.transactionDate == null || purchase.productId == null) {
          continue;
        }

        final purchaseElement =
            PurchaseElement.allPurchaseElements.getPurchaseElement(productId: purchase.productId!);

        if (purchaseElement == null) continue;

        if (DateTime.now().isAfter(purchase.transactionDate!
            .add(Duration(days: purchaseElement.subscriptionElement.days)))) {
          continue;
        }

        purchases.add(purchase);
      }

      return purchases;
    }

    if (Platform.isAndroid) {
      final purchases = await FlutterInappPurchase.instance.getAvailablePurchases();

      return purchases ?? [];
    }

    return [];
  }

  Future purchaseSubscription({required String productId}) =>
      FlutterInappPurchase.instance.requestSubscription(productId);

  _verifyPurchase({required PurchasedItem item}) {
    //TODO write some code
    debugPrint('_verifyPurchase for android');
  }
}
