import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/uni_links/uni_links_bloc.dart';
import 'package:zeusfile/presentation/account/account_screen.dart';
import 'package:zeusfile/presentation/authorization/bloc/auth_bloc.dart';
import 'package:zeusfile/presentation/download/download_screen.dart';
import 'package:zeusfile/presentation/files/files_screen.dart';
import 'package:zeusfile/presentation/main/cubit/main_screen_page_index_cubit.dart';
import 'package:zeusfile/presentation/premium/premium_screen.dart';
import 'package:zeusfile/presentation/upload/upload_screen.dart';
import 'package:zeusfile/presentation/widgets/popup_item.dart';
import 'package:zeusfile/purchase/cubit/purchase_cubit.dart';
import 'package:zeusfile/purchase/purchase_service.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main';

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();

  static Future<void> checkSubscriptions(BuildContext context) async {
    final PurchaseCubit purchaseCubit = context.read();
    final AuthBloc authBloc = context.read();

    await purchaseCubit.init(
        purchaseItemCallback: (purchasedItem) =>
            PurchaseCubit.purchasedItemCallback(context: context, purchasedItem: purchasedItem));

    final updatedServices = <ServiceType, bool>{
      ServiceType.filejoker: false,
      ServiceType.novafile: false
    };

    for (var purchasedItem in purchaseCubit.state.purchasedItems ?? <PurchasedItem>[]) {
      if (purchasedItem.productId == null) {
        continue;
      }

      final purchaseElement = PurchaseElement.allPurchaseElements
          .getPurchaseElement(productId: purchasedItem.productId!);

      if (purchaseElement == null) {
        continue;
      }

      await purchaseCubit.sendInfoAboutPurchasedItem(
          authBlocState: authBloc.state,
          purchasedItem: purchasedItem,
          purchaseElement: purchaseElement);

      updatedServices[purchaseElement.serviceType] = true;
    }

    if (updatedServices[ServiceType.filejoker]! && authBloc.state.filejokerServiceAuth.authorized) {
      final session = authBloc.state.filejokerServiceAuth.session!;
      authBloc.add(LoadAccountEvent(serviceType: ServiceType.filejoker, session: session));
    }

    if (updatedServices[ServiceType.novafile]! && authBloc.state.novafileServiceAuth.authorized) {
      final session = authBloc.state.novafileServiceAuth.session!;
      authBloc.add(LoadAccountEvent(serviceType: ServiceType.novafile, session: session));
    }

    if (authBloc.state.filejokerServiceAuth.authorized) {
      final session = authBloc.state.filejokerServiceAuth.session!;
      purchaseCubit.getSubscriptionResponseList(
          serviceType: ServiceType.filejoker, session: session);
    }

    if (authBloc.state.novafileServiceAuth.authorized) {
      final session = authBloc.state.novafileServiceAuth.session!;
      purchaseCubit.getSubscriptionResponseList(
          serviceType: ServiceType.novafile, session: session);
    }

    purchaseCubit.dispose();
  }
}

class _MainScreenState extends State<MainScreen> {
  DateTime? lastPopButtonTappedTime;

  static const Duration popButtonDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();

    // Navigating to download widget
    final UniLinksBloc uniLinksBloc = context.read();
    if (uniLinksBloc.state is UniLinksUnhandledEventState) {
      context.read<MainScreenPageIndexCubit>().setPageIndex(pageIndex: 2);
    }

    // Checking subscriptions
    MainScreen.checkSubscriptions(context);
  }

  void _onItemTapped(int index) {
    context.read<MainScreenPageIndexCubit>().setPageIndex(pageIndex: index);
  }

  final _items = [
    const AccountScreen(),
    const UploadScreen(),
    const DownloadScreen(),
    const FilesScreen(),
    const PremiumScreen()
  ];

  Future<bool> checkPopButton() async {
    if (lastPopButtonTappedTime == null) {
      lastPopButtonTappedTime = DateTime.now();
      FToast().removeQueuedCustomToasts();
      FToast().showToast(
          gravity: ToastGravity.TOP,
          toastDuration: popButtonDuration,
          child: PopUpItem(
            text: 'Tap once more to exit',
            onTap: () {
              FToast().removeQueuedCustomToasts();
            },
            textStyle: h2SbStyle,
          ));
      return false;
    }

    if (DateTime.now().isBefore(lastPopButtonTappedTime!.add(popButtonDuration))) {
      return true;
    }

    lastPopButtonTappedTime = null;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: checkPopButton,
      child: BlocBuilder<MainScreenPageIndexCubit, int>(
        builder: (context, selectedPageIndex) {
          return Scaffold(
            backgroundColor: mainBackColor,
            body: _items[selectedPageIndex],
            bottomNavigationBar: BlocListener<UniLinksBloc, UniLinksState>(
              listenWhen: (previous, current) => current is UniLinksUnhandledEventState,
              listener: (context, state) {
                // Navigating to download widget
                if (state is UniLinksUnhandledEventState) {
                  context.read<MainScreenPageIndexCubit>().setPageIndex(pageIndex: 2);
                }
              },
              child: Container(
                decoration: const BoxDecoration(color: mainBackColor),
                child: BottomNavigationBar(
                  currentIndex: selectedPageIndex,
                  onTap: _onItemTapped,
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  type: BottomNavigationBarType.fixed,
                  selectedFontSize: 10,
                  unselectedFontSize: 10,
                  unselectedLabelStyle: menuStyle,
                  selectedLabelStyle: menuActiveStyle,
                  selectedItemColor: lightOptionalColor,
                  unselectedItemColor: menuTextColor,
                  backgroundColor: mainBackColor,
                  items: [
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        selectedPageIndex == 0
                            ? 'assets/icons/account_active.svg'
                            : 'assets/icons/account.svg',
                        width: 24,
                        height: 24,
                      ),
                      label: 'My Account',
                    ),
                    BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          selectedPageIndex == 1
                              ? 'assets/icons/upload_active.svg'
                              : 'assets/icons/upload.svg',
                          width: 24,
                          height: 24,
                        ),
                        label: 'Upload'),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        selectedPageIndex == 2
                            ? 'assets/icons/download_active.svg'
                            : 'assets/icons/download.svg',
                        width: 24,
                        height: 24,
                      ),
                      label: 'Download',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        selectedPageIndex == 3
                            ? 'assets/icons/files_active.svg'
                            : 'assets/icons/files.svg',
                        width: 24,
                        height: 24,
                      ),
                      label: 'My Files',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        selectedPageIndex == 4
                            ? 'assets/icons/premium_active.svg'
                            : 'assets/icons/premium.svg',
                        width: 24,
                        height: 24,
                      ),
                      label: 'Premium',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
