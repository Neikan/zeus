import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/presentation/premium/widgets/content_period.dart';
import 'package:zeusfile/presentation/widgets/button_app.dart';
import 'package:zeusfile/presentation/widgets/popup_item.dart';
import 'package:zeusfile/purchase/cubit/purchase_cubit.dart';
import 'package:zeusfile/purchase/purchase_service.dart';

class BuyContentScreen extends StatefulWidget {
  final ServiceType serviceType;
  final SubscriptionType subscriptionType;
  const BuyContentScreen(
      {super.key, required this.serviceType, required this.subscriptionType});

  @override
  State<BuyContentScreen> createState() => _BuyContentScreenState();
  static MaterialPageRoute materialPageRoute(
          {required ServiceType serviceType,
          required SubscriptionType subscriptionType}) =>
      MaterialPageRoute(
          builder: (context) => BuyContentScreen(
                serviceType: serviceType,
                subscriptionType: subscriptionType,
              ));
}

class _BuyContentScreenState extends State<BuyContentScreen> {
  late List<PurchaseElement> currentPurchaseElemenList;
  late PurchaseElement selectedItem;
  PurchaseService get purchaseService => context.read<PurchaseService>();

  Future? purchaseProcess;

  @override
  void initState() {
    super.initState();

    currentPurchaseElemenList = PurchaseElement.getPurchaseElemetList(
        serviceType: widget.serviceType,
        subscriptionType: widget.subscriptionType);
    selectedItem = currentPurchaseElemenList.first;
  }

  List<Widget> get purchaseElements => currentPurchaseElemenList
      .map((purchaseElement) => BlocBuilder<PurchaseCubit, PurchaseCubitState>(
              builder: (context, purchaseCubitState) {
            return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedItem = purchaseElement;
                  });
                },
                child: ContentPeriod(
                    alredyBought: (purchaseCubitState.purchasedElements ??
                            <String, PurchaseElement>{})
                        .keys
                        .contains(purchaseElement.productId),
                    checkBoxBool: selectedItem == purchaseElement,
                    text: '${purchaseElement.subscriptionElement.days} days',
                    onChanged: (value) {}));
          }))
      .toList();

  Widget get purchaseProcessWidget => purchaseProcess == null
      ? ButtonApp(
          text: 'Buy Premium',
          color: accentColor,
          onTap: () {
            final PurchaseCubit purchaseCubit = context.read();

            if ((purchaseCubit.state.purchasedElements ??
                    <String, PurchaseElement>{})
                .keys
                .contains(selectedItem.productId)) {
              FToast().showToast(
                  gravity: ToastGravity.TOP,
                  toastDuration: const Duration(seconds: 3),
                  child: PopUpItem(
                    text:
                        '''Our records indicate that you currently have an active subscription.  '''
                        '''Before you can buy another one, please cancel your current recurring subscription first to avoid double billing''',
                    onTap: () {
                      FToast().removeQueuedCustomToasts();
                    },
                  ));
              return;
            }

            if (!(purchaseCubit.state.awailablePurchaseElements)
                .contains(selectedItem)) {
              FToast().showToast(
                  gravity: ToastGravity.TOP,
                  toastDuration: const Duration(seconds: 3),
                  child: PopUpItem(
                    text:
                        '''Our records indicate that you currently have an active subscription.  '''
                        '''Before you can buy another one, please cancel your current recurring subscription first to avoid double billing''',
                    onTap: () {
                      FToast().removeQueuedCustomToasts();
                    },
                  ));
              return;
            }

            purchaseCubit.purchaseSubscription(purchaseElement: selectedItem);
            setState(() {
              purchaseProcess = Future.delayed(const Duration(seconds: 8))
                  .then((value) => setState(
                        () => purchaseProcess = null,
                      ));
            });
          },
        )
      : FutureBuilder(
          future: purchaseProcess,
          builder: (context, snapshot) {
            if (snapshot.hasData || snapshot.hasError) return Container();

            return const Center(child: CircularProgressIndicator());
          });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
            left: 20, right: 20, top: MediaQuery.of(context).padding.top),
        color: extractorColor,
        child: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: SvgPicture.asset(
                        'assets/icons/back_icon.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Buy ${widget.serviceType.nameRepresent} Premium'
                            .toUpperCase(),
                        style: h3RStyle.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Divider(
                  color: accentColor,
                  thickness: 1,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: optionalColor,
                  ),
                  child: Center(
                    child: Text(
                      widget.subscriptionType.represent,
                      style: h2SbStyle.copyWith(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    // TODO replace with price
                    '\$${selectedItem.defaultPrice}',
                    style: h1Style.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    '${widget.subscriptionType.represent} access to ${widget.serviceType.nameRepresent} for ${selectedItem.subscriptionElement.days} days',
                    style: h3SbStyle,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: purchaseElements,
                ),
                const Spacer(),
                purchaseProcessWidget,
                const SizedBox(height: 10),
                Text(
                  'By making payment you are setting up recurring subscription. You can cancel your subscription at any time. By continuing, you certify that you are over 18 years of age and accept these terms and conditions.',
                  style: h2SbAzureStyle.copyWith(
                      color: menuTextColor, fontSize: 12),
                ),
                const SizedBox(height: 15),
              ]),
        ),
      ),
    );
  }
}
