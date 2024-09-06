import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/statuses_cubit/current_service_cubit.dart';
import 'package:zeusfile/presentation/account/logout_screen.dart';
import 'package:zeusfile/presentation/authorization/bloc/auth_bloc.dart';
import 'package:zeusfile/presentation/premium/entities/subscribe_data.dart';
import 'package:zeusfile/presentation/premium/widgets/premium_item.dart';
import 'package:zeusfile/presentation/widgets/button_app.dart';
import 'package:zeusfile/presentation/widgets/header_app.dart';
import 'package:zeusfile/presentation/widgets/service_chooser_bottom_sheet.dart';
import 'package:zeusfile/purchase/cubit/purchase_cubit.dart';

part 'widgets/data_error.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool isVisible = false;

  @override
  void initState() {
    super.initState();

    final PurchaseCubit purchaseCubit = context.read();
    // TODO need check?
    // if (purchaseCubit.state.status == PurchaseCubitStateStatus.initial) {
    //   reloadMarketInfo();
    // }
    reloadMarketInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentServiceCubit, ServiceType>(
      builder: (context, currentServiceType) {
        return Container(
          height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          color: deepBlueColor,
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authBlocState) {
              return BlocBuilder<PurchaseCubit, PurchaseCubitState>(
                builder: (context, purchaseCubitState) {
                  if (purchaseCubitState.status == PurchaseCubitStateStatus.initializing) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (purchaseCubitState.status == PurchaseCubitStateStatus.gotError) {
                    return _DataError(onTap: reloadMarketInfo);
                  }

                  final hasSubscription =
                      (purchaseCubitState.hasSubscription[currentServiceType] ?? false);

                  // TODO restore for test
                  // final hasSubscription =
                  //     (purchaseCubitState.hasSubscription[currentServiceType] ??
                  //         false);

                  final List<SubscribeData> subscribeData =
                      currentServiceAuth.serviceType == ServiceType.filejoker
                          ? subscribeDataFileJoker
                          : subscribeDataNovaFile;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      HeaderApp(
                        title: 'Premium Service',
                        leftIcon: SvgPicture.asset(
                          'assets/icons/check_service_icon.svg',
                          width: 24,
                          height: 24,
                        ),
                        leftTap: () => ServiceChooserBottomSheet.changeService(context),
                        rightTap: () => Navigator.of(context).push(
                          LogoutScreen.materialPageRoute(serviceType: currentServiceType),
                        ),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PremiumItem(
                                subscribeData: subscribeData[0],
                                canBuy: !hasSubscription,
                                onTap: () => setState(() {
                                  subscribeData[0].isVisible = !subscribeData[0].isVisible;
                                }),
                              ),
                              PremiumItem(
                                subscribeData: subscribeData[1],
                                canBuy: !hasSubscription,
                                onTap: () => setState(() {
                                  subscribeData[1].isVisible = !subscribeData[1].isVisible;
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                      //   child: ButtonApp(
                      //     text: 'Restore Purchase',
                      //     color: accentColor,
                      //     onTap: () async {
                      //       await MainScreen.checkSubscriptions(context);

                      //       FToast().removeQueuedCustomToasts();
                      //       FToast().showToast(
                      //         gravity: ToastGravity.TOP,
                      //         toastDuration: const Duration(seconds: 2),
                      //         child: PopUpItem(
                      //           text: 'Purchase restored',
                      //           onTap: () {
                      //             FToast().removeQueuedCustomToasts();
                      //           },
                      //           textStyle: h2SbStyle,
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  ServiceAuth get currentServiceAuth => (context.read<AuthBloc>().state is CheckedAuthState)
      ? (context.read<AuthBloc>().state as CheckedAuthState).getServiceAuth(
          serviceType: context.read<CurrentServiceCubit>().state,
        )
      : context.read<AuthBloc>().state.filejokerServiceAuth;

  Widget get alredyHaveSubscriptionWidget => Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  'Dear Customer',
                  style: h1Style.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: Text(
                  '''Our records indicate that you currently have an active subscription.  '''
                  '''Before you can buy another one, please cancel your current recurring subscription first to avoid double billing''',
                  textAlign: TextAlign.justify,
                  style: h2SbStyle.copyWith(color: Colors.white),
                ),
              ),
              // TODO restore
              // const SizedBox(
              //   height: 20,
              // ),
              // ButtonApp(
              //   text: 'Check Subscription Status',
              //   color: accentColor,
              //   onTap: reloadMarketInfo,
              // )
            ],
          ),
        ),
      );

  void reloadMarketInfo() {
    final PurchaseCubit purchaseCubit = context.read();
    purchaseCubit.init(
      purchaseItemCallback: (purchasedItem) => PurchaseCubit.purchasedItemCallback(
        context: context,
        purchasedItem: purchasedItem,
      ),
    );

    final serviceType = context.read<CurrentServiceCubit>().state;

    final session = context.read<AuthBloc>().state.getServiceAuth(serviceType: serviceType).session;

    if (session == null) return;

    context.read<AuthBloc>().add(LoadAccountEvent(
          session: session,
          serviceType: serviceType,
        ));

    purchaseCubit.getSubscriptionResponseList(session: session, serviceType: serviceType);
  }
}
