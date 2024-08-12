// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_cubit.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PurchaseCubitStateCWProxy {
  PurchaseCubitState allPurchaseElements(
      List<PurchaseElement>? allPurchaseElements);

  PurchaseCubitState initial(bool initial);

  PurchaseCubitState purchasedElements(
      Map<String, PurchaseElement>? purchasedElements);

  PurchaseCubitState purchasedItems(List<PurchasedItem>? purchasedItems);

  PurchaseCubitState subscriptionResponseMap(
      Map<ServiceType, List<SubscriptionResponse>> subscriptionResponseMap);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PurchaseCubitState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PurchaseCubitState(...).copyWith(id: 12, name: "My name")
  /// ````
  PurchaseCubitState call({
    List<PurchaseElement>? allPurchaseElements,
    bool? initial,
    Map<String, PurchaseElement>? purchasedElements,
    List<PurchasedItem>? purchasedItems,
    Map<ServiceType, List<SubscriptionResponse>>? subscriptionResponseMap,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPurchaseCubitState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPurchaseCubitState.copyWith.fieldName(...)`
class _$PurchaseCubitStateCWProxyImpl implements _$PurchaseCubitStateCWProxy {
  final PurchaseCubitState _value;

  const _$PurchaseCubitStateCWProxyImpl(this._value);

  @override
  PurchaseCubitState allPurchaseElements(
          List<PurchaseElement>? allPurchaseElements) =>
      this(allPurchaseElements: allPurchaseElements);

  @override
  PurchaseCubitState initial(bool initial) => this(initial: initial);

  @override
  PurchaseCubitState purchasedElements(
          Map<String, PurchaseElement>? purchasedElements) =>
      this(purchasedElements: purchasedElements);

  @override
  PurchaseCubitState purchasedItems(List<PurchasedItem>? purchasedItems) =>
      this(purchasedItems: purchasedItems);

  @override
  PurchaseCubitState subscriptionResponseMap(
          Map<ServiceType, List<SubscriptionResponse>>
              subscriptionResponseMap) =>
      this(subscriptionResponseMap: subscriptionResponseMap);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PurchaseCubitState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PurchaseCubitState(...).copyWith(id: 12, name: "My name")
  /// ````
  PurchaseCubitState call({
    Object? allPurchaseElements = const $CopyWithPlaceholder(),
    Object? initial = const $CopyWithPlaceholder(),
    Object? purchasedElements = const $CopyWithPlaceholder(),
    Object? purchasedItems = const $CopyWithPlaceholder(),
    Object? subscriptionResponseMap = const $CopyWithPlaceholder(),
  }) {
    return PurchaseCubitState(
      allPurchaseElements: allPurchaseElements == const $CopyWithPlaceholder()
          ? _value.allPurchaseElements
          // ignore: cast_nullable_to_non_nullable
          : allPurchaseElements as List<PurchaseElement>?,
      initial: initial == const $CopyWithPlaceholder() || initial == null
          ? _value.initial
          // ignore: cast_nullable_to_non_nullable
          : initial as bool,
      purchasedElements: purchasedElements == const $CopyWithPlaceholder()
          ? _value.purchasedElements
          // ignore: cast_nullable_to_non_nullable
          : purchasedElements as Map<String, PurchaseElement>?,
      purchasedItems: purchasedItems == const $CopyWithPlaceholder()
          ? _value.purchasedItems
          // ignore: cast_nullable_to_non_nullable
          : purchasedItems as List<PurchasedItem>?,
      subscriptionResponseMap:
          subscriptionResponseMap == const $CopyWithPlaceholder() ||
                  subscriptionResponseMap == null
              ? _value.subscriptionResponseMap
              // ignore: cast_nullable_to_non_nullable
              : subscriptionResponseMap
                  as Map<ServiceType, List<SubscriptionResponse>>,
    );
  }
}

extension $PurchaseCubitStateCopyWith on PurchaseCubitState {
  /// Returns a callable class that can be used as follows: `instanceOfPurchaseCubitState.copyWith(...)` or like so:`instanceOfPurchaseCubitState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PurchaseCubitStateCWProxy get copyWith =>
      _$PurchaseCubitStateCWProxyImpl(this);
}
