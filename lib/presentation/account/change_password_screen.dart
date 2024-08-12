import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/statuses_cubit/network_status_cubit.dart';
import 'package:zeusfile/presentation/account/change_new_password_screen.dart';
import 'package:zeusfile/presentation/authorization/bloc/auth_bloc.dart';
import 'package:zeusfile/presentation/widgets/button_app.dart';
import 'package:zeusfile/presentation/widgets/header_app.dart';
import 'package:zeusfile/presentation/widgets/text_field_app.dart';
import 'package:zeusfile/utils/enums.dart';

class ChangePasswordScreen extends StatefulWidget {
  final ServiceType serviceType;

  const ChangePasswordScreen({Key? key, required this.serviceType})
      : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();

  static MaterialPageRoute materialPageRoute(
          {required ServiceType serviceType}) =>
      MaterialPageRoute(
          builder: (context) => ChangePasswordScreen(serviceType: serviceType));
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool passwordVisible = false;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  bool get passwordValidate => _passwordController.text.trim().isNotEmpty;

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
                  // TODO set password listener logic
                  // if (state.status == NetworkStatus.initial &&
                  //     state.checkedPassword == true) {
                  //   Navigator.of(context)
                  //       .pushNamed(ChangeNewPasswordScreen.routeName);
                  // }
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
                            margin: const EdgeInsets.only(bottom: 16),
                            color: accentColor,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 64,
                            margin: const EdgeInsets.only(top: 44, bottom: 30),
                            child: Text(
                              'Enter a valid\npassword for ${widget.serviceType.nameRepresent} Cloud Service',
                              style: h1Style,
                            ),
                          ),
                          TextFieldApp(
                            label: 'Password',
                            hint: 'Enter your password',
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
                                    Navigator.of(context).pop();
                                  },
                                  color: mainBackColor,
                                  borderColor: accentColor,
                                  textStyle: h2SbWhiteStyle,
                                ),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 22,
                                child: ButtonApp(
                                  text: 'Enter',
                                  disabled: !passwordValidate,
                                  onTap: () {
                                    final authBloc = context.read<AuthBloc>();
                                    authBloc
                                        .checkPassword(CheckPassword(
                                            currentPassword:
                                                _passwordController.text,
                                            serviceType: widget.serviceType,
                                            session: authBloc.state
                                                    .getServiceAuth(
                                                        serviceType:
                                                            widget.serviceType)
                                                    .session ??
                                                ''))
                                        .then((value) {
                                      if (!value) return null;
                                      return Navigator.of(context).push(
                                          ChangeNewPasswordScreen
                                              .materialPageRoute(
                                                  serviceType:
                                                      widget.serviceType,
                                                  oldPassword:
                                                      _passwordController
                                                          .text));
                                    });
                                  },
                                  color: accentColor,
                                ),
                              ),
                            ],
                          ),
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
