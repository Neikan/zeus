import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/statuses_cubit/network_status_cubit.dart';
import 'package:zeusfile/presentation/authorization/bloc/auth_bloc.dart';
import 'package:zeusfile/presentation/main/main_screen.dart';
import 'package:zeusfile/presentation/widgets/button_app.dart';
import 'package:zeusfile/presentation/widgets/header_app.dart';
import 'package:zeusfile/presentation/widgets/popup_item.dart';
import 'package:zeusfile/presentation/widgets/text_field_app.dart';
import 'package:zeusfile/utils/enums.dart';

class ChangeNewPasswordScreen extends StatefulWidget {
  final ServiceType serviceType;
  final String oldPassword;

  const ChangeNewPasswordScreen(
      {Key? key, required this.serviceType, required this.oldPassword})
      : super(key: key);

  @override
  State<ChangeNewPasswordScreen> createState() =>
      _ChangeNewPasswordScreenState();

  static MaterialPageRoute materialPageRoute(
          {required ServiceType serviceType, required String oldPassword}) =>
      MaterialPageRoute(
          builder: (context) => ChangeNewPasswordScreen(
                serviceType: serviceType,
                oldPassword: oldPassword,
              ));
}

class _ChangeNewPasswordScreenState extends State<ChangeNewPasswordScreen> {
  bool passwordVisible = false;
  bool retypePasswordVisible = false;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();

  bool get passwordValidated =>
      _passwordController.text == _retypePasswordController.text &&
      _passwordController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(() => setState(() {}));
    _retypePasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeaderApp(
                title: 'Password',
                leftTap: () {
                  Navigator.of(context).pop();
                },
              ),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  // TODO remove this
                  // if (state.status == NetworkStatus.success &&
                  //     state.passwordChanged == true) {
                  //   Navigator.of(context).pop();
                  // }
                },
                child: Flexible(
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BlocBuilder<NetworkStatusCubit, NetworkStatus>(
                            builder: (context, state) =>
                                state == NetworkStatus.loading
                                    ? const CircularProgressIndicator()
                                    : Container(),
                          ),
                          Container(
                            height: 1,
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 16, bottom: 16),
                            color: accentColor,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 64,
                            margin: const EdgeInsets.only(top: 44, bottom: 30),
                            child: Text(
                              'Enter a new\npassword for ${widget.serviceType.nameRepresent} Cloud Service',
                              style: h1Style,
                            ),
                          ),
                          TextFieldApp(
                            label: 'New password',
                            hint: 'Enter your new password',
                            controller: _passwordController,
                            obscure: !passwordVisible,
                            icon: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => setState(() {
                                passwordVisible = !passwordVisible;
                              }),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: SvgPicture.asset(
                                  passwordVisible
                                      ? 'assets/icons/eye.svg'
                                      : 'assets/icons/eye_off.svg',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 16)),
                          TextFieldApp(
                            label: 'Retype new password',
                            hint: 'Retype your new password',
                            controller: _retypePasswordController,
                            obscure: !retypePasswordVisible,
                            icon: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => setState(() {
                                retypePasswordVisible = !retypePasswordVisible;
                              }),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: SvgPicture.asset(
                                  retypePasswordVisible
                                      ? 'assets/icons/eye.svg'
                                      : 'assets/icons/eye_off.svg',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 32)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 22,
                                child: ButtonApp(
                                  text: 'Cancel',
                                  onTap: () {
                                    Navigator.of(context).popUntil(
                                        ModalRoute.withName(
                                            MainScreen.routeName));
                                  },
                                  color: mainBackColor,
                                  borderColor: accentColor,
                                  textStyle: h2SbWhiteStyle,
                                ),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 22,
                                child: BlocBuilder<AuthBloc, AuthState>(
                                    builder: (context, state) => ButtonApp(
                                          text: 'Enter',
                                          disabled: !passwordValidated,
                                          onTap: () {
                                            context
                                                .read<AuthBloc>()
                                                .changePassword(ChangePassword(
                                                    session: state
                                                            .getServiceAuth(
                                                                serviceType: widget
                                                                    .serviceType)
                                                            .session ??
                                                        '',
                                                    serviceType:
                                                        widget.serviceType,
                                                    currentPassword:
                                                        widget.oldPassword,
                                                    newPassword:
                                                        _passwordController
                                                            .text))
                                                .then((value) {
                                              if (!value) return null;
                                              FToast()
                                                  .removeQueuedCustomToasts();
                                              FToast().showToast(
                                                  gravity: ToastGravity.TOP,
                                                  toastDuration: const Duration(
                                                      seconds: 3),
                                                  child: PopUpItem(
                                                    text:
                                                        'Password successfully changed',
                                                    onTap: () {
                                                      FToast()
                                                          .removeQueuedCustomToasts();
                                                    },
                                                    textStyle: h2SbStyle,
                                                  ));
                                              Navigator.of(context).popUntil(
                                                  ModalRoute.withName(
                                                      MainScreen.routeName));
                                              return;
                                            });
                                          },
                                          color: accentColor,
                                        )),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(top: 27)),
                          const Padding(padding: EdgeInsets.only(top: 35)),
                          Container(
                            height: 1,
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 40),
                            color: accentColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
