// ignore_for_file: avoid_print

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/statuses_cubit/current_service_cubit.dart';
import 'package:zeusfile/presentation/authorization/auth_screen.dart';
import 'package:zeusfile/presentation/widgets/text_field_app.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool passwordVisible = false;
  bool isChecked = false;

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
            padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: MediaQuery.of(context).padding.top,
                bottom: MediaQuery.of(context).padding.bottom),
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
                      'Sign Up',
                      style: h2SbStyle,
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
                    const Padding(padding: EdgeInsets.only(top: 64)),
                    const TextFieldApp(
                        label: 'Username', hint: 'Enter your user name'),
                    const Padding(padding: EdgeInsets.only(top: 16)),
                    TextFieldApp(
                      label: 'Email',
                      hint: 'Enter your email',
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: SvgPicture.asset(
                          'assets/icons/mail.svg',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 16)),
                    TextFieldApp(
                      label: 'Password',
                      hint: 'Enter your password',
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
                      label: 'Re-tupe your password',
                      hint: 'Re-tupe your password',
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
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() {
                        isChecked = !isChecked;
                      }),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            isChecked
                                ? 'assets/icons/checkbox_checked.svg'
                                : 'assets/icons/checkbox.svg',
                            width: 24,
                            height: 24,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: RichText(
                                text: TextSpan(
                                    text:
                                        'I have read and agree to the Novafile',
                                    style: h3RStyle,
                                    children: [
                                  TextSpan(
                                      text: ' ToS',
                                      style: h3RAccentStyle,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => print('ON TAP'))
                                ])),
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 32)),
                    GestureDetector(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const BoxDecoration(
                            color: accentColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(23))),
                        child: const Center(
                            child: Text('Register', style: h2SbStyle)),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 8)),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).push(
                          AuthScreen.materialPageRoute(
                              serviceType:
                                  context.read<CurrentServiceCubit>().state)),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child:
                            const Center(child: Text('Login', style: h2RStyle)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
