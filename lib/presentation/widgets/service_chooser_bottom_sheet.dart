import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/statuses_cubit/current_service_cubit.dart';
import 'package:zeusfile/presentation/authorization/auth_screen.dart';
import 'package:zeusfile/presentation/authorization/bloc/auth_bloc.dart';
import 'package:zeusfile/presentation/widgets/modal_menu.dart';

class ServiceChooserBottomSheet extends StatelessWidget {
  final bool changeDefaultService;
  final String? title;
  const ServiceChooserBottomSheet(
      {super.key, this.changeDefaultService = true, this.title});

  static Future<bool> switchService(BuildContext context,
      {required ServiceType serviceType}) async {
    final currentServiceType = context.read<CurrentServiceCubit>().state;
    final authBlocState = context.read<AuthBloc>().state;

    if (currentServiceType == serviceType) {
      return true;
    }

    if (authBlocState.getServiceAuth(serviceType: serviceType).authorized) {
      // ignore: use_build_context_synchronously
      context.read<CurrentServiceCubit>().service(serviceType: serviceType);
      return true;
    }

    // ignore: use_build_context_synchronously
    final result = await Navigator.of(context)
        .push(AuthScreen.materialPageRoute(serviceType: serviceType));

    if (result is bool) return result;

    return false;
  }

  static Future<bool> changeService(BuildContext context,
      {String? title}) async {
    final currentServiceType = context.read<CurrentServiceCubit>().state;
    final authBlocState = context.read<AuthBloc>().state;
    final serviceType = await ServiceChooserBottomSheet.showModalMenu(context,
        changeDefaultService: false, title: title);

    if (serviceType == null) return false;

    if (currentServiceType == serviceType) {
      return true;
    }

    if (authBlocState.getServiceAuth(serviceType: serviceType).authorized) {
      // ignore: use_build_context_synchronously
      context.read<CurrentServiceCubit>().service(serviceType: serviceType);
      return true;
    }

    // ignore: use_build_context_synchronously
    final result = await Navigator.of(context)
        .push(AuthScreen.materialPageRoute(serviceType: serviceType));

    if (result is bool) return result;

    return false;
  }

  static Future<ServiceType?> showModalMenu(BuildContext context,
          {bool changeDefaultService = true, String? title}) =>
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => ServiceChooserBottomSheet(
                changeDefaultService: changeDefaultService,
                title: title,
              )).then((serviceType) =>
          serviceType == null ? null : serviceType as ServiceType);

  @override
  Widget build(BuildContext context) => ModalMenu(
        title: title ?? 'Change Cloud Service',
        items: [
          ...services.keys.map((serviceType) {
            return ModalMenuItem(
                title: serviceType.nameRepresent,
                icon: SvgPicture.asset(
                  'assets/icons/server_icon.svg',
                  width: 24,
                  height: 24,
                ),
                onTap: () {
                  final CurrentServiceCubit currentServiceCubit =
                      context.read<CurrentServiceCubit>();

                  if (currentServiceCubit.state != serviceType &&
                      changeDefaultService) {
                    currentServiceCubit.service(serviceType: serviceType);
                  }

                  Navigator.of(context).pop(serviceType);
                });
          }),
        ],
      );
}
