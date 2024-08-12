import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/statuses_cubit/current_service_cubit.dart';
import 'package:zeusfile/data/statuses_cubit/network_status_cubit.dart';
import 'package:zeusfile/presentation/authorization/bloc/auth_bloc.dart';
import 'package:zeusfile/presentation/authorization/restore_password_screen.dart';
import 'package:zeusfile/presentation/widgets/button_app.dart';
import 'package:zeusfile/presentation/widgets/privacy_info.dart';
import 'package:zeusfile/presentation/widgets/text_field_app.dart';
// ignore: unused_import
import 'package:zeusfile/utils/enums.dart';

class AuthScreen extends StatefulWidget {
  final ServiceType serviceType;

  const AuthScreen({super.key, required this.serviceType});

  @override
  State<AuthScreen> createState() => _AuthScreenState();

  static MaterialPageRoute materialPageRoute(
          {required ServiceType serviceType}) =>
      MaterialPageRoute(
          builder: (context) => AuthScreen(serviceType: serviceType));
}

class _AuthScreenState extends State<AuthScreen> {
  bool passwordVisible = false;

  late TextEditingController _emailController;

  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    // TODO restore to email and password autofill
    // _emailController = TextEditingController(
    //     text: widget.serviceType == ServiceType.filejoker
    //         ? 'zeuscloud2022@gmail.com'
    //         : 'zeuscloud2022@gmail.com');

    // _passwordController = TextEditingController(
    //     text: widget.serviceType == ServiceType.filejoker
    //         ? '1234567890'
    //         : '1234567890');

    // TODO restore
    _emailController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');

    _loadEmail();

    // TODO add password validation
    // Future.delayed(Duration.zero, () {
    //   final login = BlocProvider.of<AuthBloc>(context).state.login;

    //   _emailController.text = login ?? '';
    //   _emailController.addListener(() {
    //     setState(() {
    //       validateData = _emailController.text.length > 3 &&
    //           _passwordController.text.length > 5 &&
    //           _passwordController.text.length < 26;
    //     });
    //   });

    //   _passwordController.addListener(() {
    //     setState(() {
    //       validateData = _emailController.text.length > 3 &&
    //           _passwordController.text.length > 5 &&
    //           _passwordController.text.length < 26;
    //     });
    //   });
    // });
  }

  Future<void> _loadEmail() async {
    final email = await BlocProvider.of<AuthBloc>(context)
        .getEmailFromStorage(widget.serviceType);
    if (email != null && email != 'null') {
      _emailController.text = email;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final service = ModalRoute.of(context)!.settings.arguments as String? ??
    //     services.keys.toList()[0];

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
            child: BlocListener<AuthBloc, AuthState>(
              listenWhen: (previous, current) =>
                  previous
                      .getServiceAuth(serviceType: widget.serviceType)
                      .authorized !=
                  current
                      .getServiceAuth(serviceType: widget.serviceType)
                      .authorized,
              listener: (context, state) {
                if (state
                    .getServiceAuth(serviceType: widget.serviceType)
                    .authorized) {
                  context
                      .read<CurrentServiceCubit>()
                      .service(serviceType: widget.serviceType);
                }
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop(true);
                }
              },
              child: BlocBuilder<NetworkStatusCubit, NetworkStatus>(
                  builder: (context, networkStatusState) => Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).padding.top +
                                          20)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Navigator.of(context).canPop()
                                      ? GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: SvgPicture.asset(
                                            'assets/icons/back_icon.svg',
                                            width: 24,
                                            height: 24,
                                          ),
                                        )
                                      : const SizedBox(
                                          width: 24,
                                          height: 24,
                                        ),
                                  const Text(
                                    'Sign In',
                                    style: h2SbWhiteStyle,
                                  ),
                                  const SizedBox(
                                    width: 24,
                                    height: 24,
                                  )
                                ],
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 30)),
                              SvgPicture.asset(
                                'assets/icons/logo.svg',
                                width: 88,
                                height: 81,
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 20)),
                              const Text(
                                'Zeus File Manager',
                                style: h1Style,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              TextFieldApp(
                                disabled: true,
                                label: 'Service',
                                controller: TextEditingController(
                                    text: widget.serviceType.nameRepresent),
                                hint: 'Current service',
                              ),
                              const Padding(padding: EdgeInsets.only(top: 32)),
                              TextFieldApp(
                                label: 'Email',
                                hint: 'Enter your email',
                                controller: _emailController,
                                textInputType: TextInputType.emailAddress,
                              ),
                              const Padding(padding: EdgeInsets.only(top: 16)),
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
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Navigator.of(context).push(
                                      RestorePasswordScreen.materialPageRoute(
                                          serviceType: widget.serviceType));
                                },
                                child: Row(
                                  children: [
                                    const Text(
                                      'Forgot your password?',
                                      style: h3RStyle,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: SvgPicture.asset(
                                        'assets/icons/arrow-up-right.svg',
                                        width: 24,
                                        height: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 32)),
                              BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) => ButtonApp(
                                        text: 'Sign In',
                                        disabled: networkStatusState ==
                                            NetworkStatus.loading,
                                        onTap: () {
                                          final AuthBloc authBloc =
                                              context.read();

                                          authBloc.add(LoginEvent(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                              serviceType: widget.serviceType));
                                        },
                                        color: accentColor,
                                      )),
                              const Padding(padding: EdgeInsets.only(top: 8)),

                              // Privacy info
                              const PrivacyInfo()

                              // TODO remove
                              // GestureDetector(
                              //   behavior: HitTestBehavior.opaque,
                              //   onTap: () => Navigator.of(context)
                              //       .pushNamed(RegisterScreen.routeName),
                              //   child: Container(
                              //     width: double.infinity,
                              //     padding: const EdgeInsets.symmetric(vertical: 12),
                              //     child: const Center(
                              //         child:
                              //             Text('Register new account', style: h2RStyle)),
                              //   ),
                              // )
                            ],
                          ),
                        ],
                      )),
            ),
          ),
        ),
      ),
    );
  }
}
