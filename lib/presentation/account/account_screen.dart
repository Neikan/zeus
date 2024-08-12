import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/statuses_cubit/current_service_cubit.dart';
import 'package:zeusfile/presentation/account/change_password_screen.dart';
import 'package:zeusfile/presentation/account/logout_screen.dart';
import 'package:zeusfile/presentation/account/premium_block.dart';
import 'package:zeusfile/presentation/account/text_field_account.dart';
import 'package:zeusfile/presentation/authorization/bloc/auth_bloc.dart';
import 'package:zeusfile/presentation/widgets/header_app.dart';
import 'package:zeusfile/presentation/widgets/privacy_info.dart';
import 'package:zeusfile/presentation/widgets/service_chooser_bottom_sheet.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // ignore: unused_field
  final TextEditingController _couponController =
      TextEditingController(text: 'Activate coupon');

  final TextEditingController _passwordController =
      TextEditingController(text: 'Password');

  ServiceAuth get currentServiceAuth =>
      (context.read<AuthBloc>().state is CheckedAuthState)
          ? (context.read<AuthBloc>().state as CheckedAuthState).getServiceAuth(
              serviceType: context.read<CurrentServiceCubit>().state)
          : context.read<AuthBloc>().state.filejokerServiceAuth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authBlocState) => BlocBuilder<
                    CurrentServiceCubit, ServiceType>(
                builder: (context, currentServiceType) => Container(
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      child: Column(children: [
                        HeaderApp(
                          title: 'My Account',
                          rightTap: () => Navigator.of(context).push(
                              LogoutScreen.materialPageRoute(
                                  serviceType: currentServiceType)),
                          leftIcon: SvgPicture.asset(
                            'assets/icons/check_service_icon.svg',
                            width: 24,
                            height: 24,
                          ),
                          leftTap: () =>
                              ServiceChooserBottomSheet.changeService(context),
                        ),
                        Flexible(
                            child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                PremiumBlock(
                                  serviceType: currentServiceType,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: const Text(
                                    'Account',
                                    style: novaStyle,
                                  ),
                                ),
                                TextFieldAccount(
                                  iconPath: 'assets/icons/profile_icon.svg',
                                  label: 'Username',
                                  controller: TextEditingController(
                                      text: authBlocState
                                              .getServiceAuth(
                                                  serviceType:
                                                      currentServiceType)
                                              .account
                                              ?.login ??
                                          ''),
                                  disabled: true,
                                ),
                                TextFieldAccount(
                                  iconPath: 'assets/icons/mail_icon.svg',
                                  label: 'Email',
                                  controller: TextEditingController(
                                      text: authBlocState
                                              .getServiceAuth(
                                                  serviceType:
                                                      currentServiceType)
                                              .account
                                              ?.email ??
                                          ''),
                                  disabled: true,
                                ),
                                TextFieldAccount(
                                  iconPath: 'assets/icons/chart_icon.svg',
                                  label: 'Traffic avaliable',
                                  controller: TextEditingController(
                                      text: authBlocState
                                              .getServiceAuth(
                                                  serviceType:
                                                      currentServiceType)
                                              .account
                                              ?.traffic ??
                                          ''),
                                  disabled: true,
                                ),
                                // TODO Remove?
                                // Container(
                                //   margin: const EdgeInsets.symmetric(
                                //       horizontal: 16, vertical: 16),
                                //   child: const Text(
                                //     'Promotions',
                                //     style: novaStyle,
                                //   ),
                                // ),
                                // GestureDetector(
                                //   behavior: HitTestBehavior.opaque,
                                //   onTap: () {
                                //     Navigator.of(context)
                                //         .pushNamed(PromocodeScreen.routeName);
                                //   },
                                //   child: TextFieldAccount(
                                //     iconPath: 'assets/icons/ticket_icon.svg',
                                //     controller: _couponController,
                                //     disabled: true,
                                //   ),
                                // ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: const Text(
                                    'Update password',
                                    style: novaStyle,
                                  ),
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    Navigator.of(context).push(
                                        ChangePasswordScreen.materialPageRoute(
                                            serviceType: currentServiceType));
                                  },
                                  child: TextFieldAccount(
                                    iconPath: 'assets/icons/lock_icon.svg',
                                    controller: _passwordController,
                                    disabled: true,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: const Text(
                                    'Change Cloud Service',
                                    style: novaStyle,
                                  ),
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () =>
                                      ServiceChooserBottomSheet.changeService(
                                          context),
                                  child: TextFieldAccount(
                                    iconPath: 'assets/icons/server_icon.svg',
                                    controller: TextEditingController(
                                        text: currentServiceType.nameRepresent),
                                    disabled: true,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 15),
                                ),

                                // Privacy policy
                                const PrivacyInfo(textAlign: TextAlign.left),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 15),
                                ),
                              ]),
                        ))
                      ]),
                    ))),
      );
}
