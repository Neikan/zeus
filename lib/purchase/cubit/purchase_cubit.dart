import 'dart:convert';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/auth/auth_rest.dart';
import 'package:zeusfile/presentation/authorization/bloc/auth_bloc.dart';
import 'package:zeusfile/purchase/purchase_service.dart';
import 'package:zeusfile/repository/auth_repository.dart';

part 'purchase_cubit.g.dart';
part 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseCubitState> {
  final PurchaseService purchaseService;
  final AuthRepository authRepository;

  PurchaseCubit({required this.purchaseService, required this.authRepository})
      : super(const PurchaseCubitState.init());

  Future<void> init(
      {required void Function(PurchasedItem? purchasedItem)
          purchaseItemCallback}) async {
    emit(state.copyWith(
        initial: false, allPurchaseElements: null, purchasedElements: null));

    await purchaseService.init(purchaseCallback: purchaseItemCallback);

    final listIAPI = await purchaseService.getSubscriptions();

    if (listIAPI.isEmpty) {
      emit(state.copyWith(
        allPurchaseElements: [],
      ));
      return;
    }

    PurchaseElement.listIAPI = listIAPI;

    emit(state.copyWith(
      allPurchaseElements: PurchaseElement.allPurchaseElements,
    ));

    await getPurchasedElements();
  }

  void dispose() {
    purchaseService.dispose();
  }

  Future<List<SubscriptionResponse>?> getSubscriptionResponseList(
      {required String session, required ServiceType serviceType}) async {
    final subscriptionResponseList = await authRepository
        .getSubscriptionResponseList(service: serviceType, session: session);

    if (subscriptionResponseList == null) return null;

    emit(state.copyWith(
        subscriptionResponseMap: {...state.subscriptionResponseMap}
          ..addAll({serviceType: subscriptionResponseList})));

    return subscriptionResponseList;
  }

  String getAllPurchaseElementsJson() {
    final subscriptionResponses = PurchaseElement.allPurchaseElements
        .map((purchaseElement) => SubscriptionResponse(
            productId: purchaseElement.productId,
            isActiveInt: 0,
            expireAt: null))
        .toList();

    return jsonEncode(subscriptionResponses);
  }

  Future<void> getPurchasedElements() async {
    final purchasedItems = await purchaseService.checkForSubscriptions();
    final purchasedElements = {
      for (var element in (state.allPurchaseElements ?? [])
          .getPurchasedElements(listIAPI: purchasedItems))
        element.productId: element
    };

    emit(state.copyWith(
      purchasedItems: purchasedItems,
      purchasedElements: purchasedElements,
    ));
  }

  Future<void> sendInfoAboutPurchasedItem(
      {required AuthState authBlocState,
      required PurchasedItem purchasedItem,
      required PurchaseElement purchaseElement}) async {
    final serviceAuth =
        authBlocState.getServiceAuth(serviceType: purchaseElement.serviceType);

    if (!serviceAuth.authorized) return;

    return authRepository.upgrade(
        session: serviceAuth.session!,
        service: purchaseElement.serviceType,
        purchasedItem: purchasedItem);
  }

  static void purchasedItemCallback(
      {required BuildContext context, required PurchasedItem? purchasedItem}) {
    final AuthBloc authBloc = context.read();
    final PurchaseCubit purchaseCubit = context.read();

    purchaseCubit.purchasedItem(
        authBlocState: authBloc.state, purchasedItem: purchasedItem);
  }

  void purchasedItem(
      {required AuthState authBlocState,
      required PurchasedItem? purchasedItem}) async {
    if (purchasedItem == null || purchasedItem.transactionId == null) return;

    final purchaseElement = PurchaseElement.allPurchaseElements
        .getPurchaseElement(productId: purchasedItem.productId!);

    if (purchaseElement == null) return;

    await sendInfoAboutPurchasedItem(
        authBlocState: authBlocState,
        purchaseElement: purchaseElement,
        purchasedItem: purchasedItem);

    FlutterInappPurchase.instance.finishTransaction(purchasedItem);

    getPurchasedElements();
  }

  Future purchaseSubscription({required PurchaseElement purchaseElement}) =>
      purchaseService.purchaseSubscription(
          productId: purchaseElement.productId);
}
