part of 'purchase_cubit.dart';

enum PurchaseCubitStateStatus { initial, initializing, gotError, success }

@CopyWith()
class PurchaseCubitState extends Equatable {
  final bool initial;

  final Map<ServiceType, List<SubscriptionResponse>> subscriptionResponseMap;

  // All products
  final List<PurchaseElement>? allPurchaseElements;

  // Purchased products {productId: PurchaseElement}
  final Map<String, PurchaseElement>? purchasedElements;

  final List<PurchasedItem>? purchasedItems;

  const PurchaseCubitState({
    this.allPurchaseElements = const [],
    this.purchasedElements = const {},
    this.purchasedItems = const [],
    this.initial = false,
    this.subscriptionResponseMap = const {},
  });

  const PurchaseCubitState.init()
      : allPurchaseElements = null,
        purchasedElements = null,
        purchasedItems = null,
        subscriptionResponseMap = const {},
        initial = true;

  Iterable<SubscriptionResponse> get allSubscriptionResponse => [
        ...?subscriptionResponseMap[ServiceType.filejoker],
        ...?subscriptionResponseMap[ServiceType.novafile]
      ];

  Map<ServiceType, bool> get hasSubscription => {
        ServiceType.filejoker:
            subscriptionResponseMap[ServiceType.filejoker]?.any((element) => element.isActive) ??
                false,
        ServiceType.novafile:
            subscriptionResponseMap[ServiceType.novafile]?.any((element) => element.isActive) ??
                false,
      };

  bool get hasAnySubscription => (allSubscriptionResponse.any((element) => element.isActive));

  List<SubscriptionType> get purchasedSubscriptionType => (purchasedElements ?? {})
      .values
      .map((value) => value.subscriptionElement.subscriptionType)
      .toList();

  List<PurchaseElement> get awailablePurchaseElements => (allPurchaseElements ?? [])
      .where((element) =>
          !purchasedSubscriptionType.contains(element.subscriptionElement.subscriptionType))
      .toList();

  PurchaseCubitStateStatus get status {
    if (initial) return PurchaseCubitStateStatus.initial;

    if (allPurchaseElements != null &&
        purchasedElements != null &&
        allPurchaseElements!.isNotEmpty) {
      return PurchaseCubitStateStatus.success;
    }

    if (allPurchaseElements != null && allPurchaseElements!.isEmpty) {
      return PurchaseCubitStateStatus.gotError;
    }

    return PurchaseCubitStateStatus.initializing;
  }

  @override
  List<Object?> get props => [
        initial,
        allPurchaseElements,
        purchasedElements,
        purchasedItems,
        status,
      ];
}
