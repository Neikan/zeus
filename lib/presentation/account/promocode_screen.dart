import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/presentation/authorization/bloc/auth_bloc.dart';
import 'package:zeusfile/presentation/widgets/button_app.dart';
import 'package:zeusfile/presentation/widgets/header_app.dart';
import 'package:zeusfile/presentation/widgets/text_field_app.dart';

class PromocodeScreen extends StatefulWidget {
  static const routeName = '/coupon';

  const PromocodeScreen({Key? key}) : super(key: key);

  @override
  State<PromocodeScreen> createState() => _PromocodeScreenState();
}

class _PromocodeScreenState extends State<PromocodeScreen> {
  bool validateData = false;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(() {
      setState(() {
        validateData = _passwordController.text.length > 3;
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
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
                title: 'Activate coupon',
                leftTap: () {
                  Navigator.of(context).pop();
                },
              ),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  // TODO promocode screen listener logic
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
                          Container(
                            height: 1,
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 16),
                            color: accentColor,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 64,
                            margin: const EdgeInsets.only(top: 44, bottom: 30),
                            child: const Text(
                              'Activate coupon\ncode',
                              style: h1Style,
                            ),
                          ),
                          TextFieldApp(
                            label: 'Coupon code',
                            hint: 'Enter your coupon code',
                            controller: _passwordController,
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: SvgPicture.asset(
                                'assets/icons/ticket_icon.svg',
                                width: 20,
                                height: 20,
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
                                  disabled: !validateData,
                                  onTap: () async {
                                    // TODO added promocode screen apply logic
                                    // BlocProvider.of<AuthBloc>(context).add(
                                    //     Promocode(
                                    //         session: BlocProvider.of<AuthBloc>(
                                    //                 context)
                                    //             .state
                                    //             .session!,
                                    //         premiumKey:
                                    //             _passwordController.text));
                                  },
                                  color: accentColor,
                                ),
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
