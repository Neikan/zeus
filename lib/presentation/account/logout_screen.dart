import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/statuses_cubit/current_service_cubit.dart';
import 'package:zeusfile/data/statuses_cubit/network_status_cubit.dart';
import 'package:zeusfile/presentation/authorization/bloc/auth_bloc.dart';
import 'package:zeusfile/presentation/widgets/button_app.dart';
import 'package:zeusfile/presentation/widgets/header_app.dart';
import 'package:zeusfile/utils/enums.dart';

class LogoutScreen extends StatelessWidget {
  final ServiceType serviceType;

  const LogoutScreen({super.key, required this.serviceType});

  static MaterialPageRoute materialPageRoute(
          {required ServiceType serviceType}) =>
      MaterialPageRoute(
          builder: (context) => LogoutScreen(serviceType: serviceType));

  ServiceAuth getCurrentServiceAuth(BuildContext context) =>
      (context.read<AuthBloc>().state is CheckedAuthState)
          ? (context.read<AuthBloc>().state as CheckedAuthState).getServiceAuth(
              serviceType: context.read<CurrentServiceCubit>().state)
          : context.read<AuthBloc>().state.filejokerServiceAuth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
              previous.getServiceAuth(serviceType: serviceType).authorized !=
              current.getServiceAuth(serviceType: serviceType).authorized,
          listener: (context, state) => Navigator.of(context).canPop()
              ? Navigator.of(context).pop()
              : null,
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderApp(
                  title: 'Logout',
                  leftTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                Flexible(
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
                              'Do you really want to logout?',
                              style: h1Style,
                            ),
                          ),
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
                                child: BlocBuilder<NetworkStatusCubit,
                                    NetworkStatus>(
                                  builder: (context, currentNetworkStatus) {
                                    return ButtonApp(
                                      text: 'Logout',
                                      onTap: () {
                                        final authBloc =
                                            BlocProvider.of<AuthBloc>(context);
                                        final authBlocState =
                                            authBloc.state as CheckedAuthState;
                                        authBloc.add(LogoutEvent(
                                            session: authBlocState
                                                    .getServiceAuth(
                                                        serviceType:
                                                            serviceType)
                                                    .session ??
                                                '',
                                            serviceType: serviceType));
                                        // TODO add logout logic
                                        // BlocProvider.of<AuthBloc>(context).add(Logout(
                                        //     session:
                                        //         BlocProvider.of<AuthBloc>(context)
                                        //             .state
                                        //             .session,
                                        //     service:
                                        //         BlocProvider.of<AuthBloc>(context)
                                        //             .state
                                        //             .currentService));
                                        // Navigator.of(context).pushNamedAndRemoveUntil(
                                        //     AuthScreen.routeName, (route) => false);
                                      },
                                      disabled: currentNetworkStatus ==
                                          NetworkStatus.loading,
                                      color: accentColor,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(top: 35)),
                          Container(
                            height: 1,
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 70),
                            color: accentColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
