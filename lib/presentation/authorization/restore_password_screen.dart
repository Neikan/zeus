import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/statuses_cubit/current_service_cubit.dart';
import 'package:zeusfile/data/statuses_cubit/network_status_cubit.dart';
import 'package:zeusfile/presentation/widgets/button_app.dart';
import 'package:zeusfile/presentation/widgets/text_field_app.dart';
import 'package:zeusfile/utils/enums.dart';

import 'bloc/auth_bloc.dart';

class RestorePasswordScreen extends StatefulWidget {
  final ServiceType serviceType;

  const RestorePasswordScreen({Key? key, required this.serviceType})
      : super(key: key);

  static MaterialPageRoute materialPageRoute(
          {required ServiceType serviceType}) =>
      MaterialPageRoute(
          builder: (context) =>
              RestorePasswordScreen(serviceType: serviceType));

  @override
  State<RestorePasswordScreen> createState() => _RestorePasswordScreenState();
}

class _RestorePasswordScreenState extends State<RestorePasswordScreen> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                                    'Restore Password',
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
                                label: 'Email or login',
                                hint: 'Enter your email or login',
                                controller: _emailController,
                                textInputType: TextInputType.emailAddress,
                              ),
                              const Padding(padding: EdgeInsets.only(top: 32)),
                              BlocBuilder<AuthBloc, AuthState>(
                                  builder: (context, state) => ButtonApp(
                                        text: 'Remind my password',
                                        disabled: networkStatusState ==
                                            NetworkStatus.loading,
                                        onTap: () {
                                          context
                                              .read<AuthBloc>()
                                              .restorePassword(RestorePassword(
                                                serviceType: widget.serviceType,
                                                email: _emailController.text,
                                              ))
                                              .then((value) {
                                            if (!value) return null;

                                            Navigator.of(context).pop();
                                            return;
                                          });
                                        },
                                        color: accentColor,
                                      )),
                              const Padding(padding: EdgeInsets.only(top: 8)),
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
