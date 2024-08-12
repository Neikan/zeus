import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/statuses_cubit/current_service_cubit.dart';
import 'package:zeusfile/presentation/premium/buy_content.dart';
import 'package:zeusfile/presentation/premium/premium_screen.dart';
import 'package:zeusfile/presentation/widgets/button_app.dart';
import 'package:zeusfile/presentation/widgets/popup_item.dart';

class PremiumItem extends StatelessWidget {
  final SubscribeData subscribeData;
  final Function() onTap;
  final bool canBuy;

  bool get isVisible => subscribeData.isVisible;

  const PremiumItem({
    Key? key,
    required this.subscribeData,
    required this.onTap,
    required this.canBuy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: extractorColor,
      ),
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
            ),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: optionalColor,
                boxShadow: [
                  BoxShadow(
                      color: mainBackColor,
                      blurRadius: 1.0,
                      offset: Offset(0.0, 1.2))
                ]),
            child: Center(
              child: Text(
                subscribeData.name,
                style: h2SbStyle.copyWith(color: Colors.white),
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 12),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: extractorColor)),
            child: Column(children: [
              Center(
                child: RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                    text: 'As low as  ',
                    style: h3RStyle,
                  ),
                  TextSpan(
                    text: '\$${subscribeData.price}',
                    style: h1Style.copyWith(color: Colors.white),
                  ),
                  const TextSpan(
                    text: '  per month',
                    style: h3RStyle,
                  ),
                ])),
              ),
              const SizedBox(height: 20),
              !isVisible
                  ? GestureDetector(
                      onTap: onTap,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 2,
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: accentColor,
                            ),
                          ),
                          Positioned(
                            top: -0.5,
                            child: Container(
                              width: MediaQuery.of(context).size.width - 65,
                              height: 35,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: extractorColor,
                              ),
                              child: Text(
                                "Show more info",
                                textAlign: TextAlign.center,
                                style: h2SbStyle.copyWith(color: accentColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              isVisible
                  ? Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/arrow-up-right.svg',
                                  width: 20,
                                  height: 20,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 16),
                                  padding: const EdgeInsets.only(bottom: 16),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8 -
                                          92,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: optionalColor))),
                                  child: Text(
                                    subscribeData.traffic,
                                    style: h3RStyle,
                                  ),
                                )
                              ]),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/arrow-up-right.svg',
                                  width: 20,
                                  height: 20,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 16),
                                  padding: const EdgeInsets.only(bottom: 16),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8 -
                                          92,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: optionalColor))),
                                  child: Text(
                                    subscribeData.detailSubscribe.premium,
                                    style: h3RStyle,
                                  ),
                                )
                              ]),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/arrow-up-right.svg',
                                  width: 20,
                                  height: 20,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 16),
                                  padding: const EdgeInsets.only(bottom: 16),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8 -
                                          92,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: optionalColor))),
                                  child: Text(
                                    subscribeData.detailSubscribe.traffic,
                                    style: h3RStyle,
                                  ),
                                )
                              ]),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/arrow-up-right.svg',
                                  width: 20,
                                  height: 20,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 16),
                                  padding: const EdgeInsets.only(bottom: 16),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8 -
                                          92,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: optionalColor))),
                                  child: Text(
                                    subscribeData.detailSubscribe.space,
                                    style: h3RStyle,
                                  ),
                                )
                              ]),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/arrow-up-right.svg',
                                  width: 20,
                                  height: 20,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 16),
                                  padding: const EdgeInsets.only(bottom: 16),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8 -
                                          92,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: optionalColor))),
                                  child: Text(
                                    subscribeData.detailSubscribe.size,
                                    style: h3RStyle,
                                  ),
                                )
                              ]),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/arrow-up-right.svg',
                                  width: 20,
                                  height: 20,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 16),
                                  padding: const EdgeInsets.only(bottom: 16),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8 -
                                          92,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: optionalColor))),
                                  child: Text(
                                    subscribeData.detailSubscribe.channel,
                                    style: h3RStyle,
                                  ),
                                )
                              ]),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/arrow-up-right.svg',
                                  width: 20,
                                  height: 20,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 16),
                                  padding: const EdgeInsets.only(bottom: 16),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8 -
                                          92,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: optionalColor))),
                                  child: Text(
                                    subscribeData.detailSubscribe.prioroty,
                                    style: h3RStyle,
                                  ),
                                )
                              ]),
                        ),
                        const Visibility(
                            visible: true, child: SizedBox(height: 45)),
                        Visibility(
                          visible: true,
                          child: BlocBuilder<CurrentServiceCubit, ServiceType>(
                            builder: (context, currentServiceType) {
                              return ButtonApp(
                                text: 'Select Plan',
                                color: accentColor,
                                onTap: () {
                                  if (canBuy != true) {
                                    FToast().showToast(
                                        gravity: ToastGravity.TOP,
                                        toastDuration:
                                            const Duration(seconds: 60),
                                        child: PopUpItem(
                                          text:
                                              'Our records indicate that you currently have an active subscription through Apple App Store. Before you can buy another subscription or upgrade your account through App Store, please cancel your current recurring subscription first to avoid double billing.',
                                          onTap: () {
                                            FToast().removeQueuedCustomToasts();
                                          },
                                        ));
                                    return;
                                  }
                                  Navigator.of(context).push(
                                      BuyContentScreen.materialPageRoute(
                                          serviceType: currentServiceType,
                                          subscriptionType:
                                              subscribeData.subscriptionType));
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    )
                  : Container()
            ]),
          ),
        ],
      ),
    );
  }
}
