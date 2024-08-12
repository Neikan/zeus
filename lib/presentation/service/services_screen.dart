import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/statuses_cubit/current_service_cubit.dart';
import 'package:zeusfile/presentation/authorization/auth_screen.dart';
import 'package:zeusfile/presentation/widgets/button_app.dart';
import 'package:zeusfile/presentation/widgets/privacy_info.dart';
import 'package:zeusfile/presentation/widgets/service_chooser_bottom_sheet.dart';
import 'package:zeusfile/presentation/widgets/text_field_app.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  static const routeName = '/services';

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.bottom -
                  MediaQuery.of(context).padding.top,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + 20)),
                    const Text(
                      'Sign In',
                      style: h2SbWhiteStyle,
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 30)),
                    SvgPicture.asset(
                      'assets/icons/logo.svg',
                      width: 88,
                      height: 81,
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 20)),
                    const Text(
                      'Zeus File Manager',
                      style: h1Style,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Column(
                  children: [
                    BlocBuilder<CurrentServiceCubit, ServiceType>(
                        builder: (context, currentServiceType) =>
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () =>
                                  ServiceChooserBottomSheet.showModalMenu(
                                      context),
                              child: TextFieldApp(
                                disabled: true,
                                controller: TextEditingController(
                                    text: currentServiceType.nameRepresent),
                                hint: 'Change Cloud Service',
                                label: 'Pick a service to use',
                                icon: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: SvgPicture.asset(
                                    'assets/icons/dropdown_icon.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            )),
                    const Padding(padding: EdgeInsets.only(top: 32)),
                    BlocBuilder<CurrentServiceCubit, ServiceType>(
                        builder: (context, currentServiceType) => ButtonApp(
                              text: 'Login',
                              disabled: false,
                              onTap: () => Navigator.of(context).push(
                                  AuthScreen.materialPageRoute(
                                      serviceType: currentServiceType)),
                              color: accentColor,
                            )),
                    const Padding(padding: EdgeInsets.only(top: 8)),
                  ],
                ),
                // Privacy info
                const PrivacyInfo()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
