import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/statuses_cubit/current_service_cubit.dart';

class HeaderApp extends StatelessWidget {
  final String title;
  final Function()? rightTap;
  final Function()? leftTap;
  final Widget? leftIcon;
  const HeaderApp(
      {Key? key,
      required this.title,
      this.rightTap,
      this.leftTap,
      this.leftIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize: MainAxisSize.min,
          children: [
            leftTap != null
                ? GestureDetector(
                    onTap: leftTap,
                    child: leftIcon ??
                        SvgPicture.asset(
                          'assets/icons/back_icon.svg',
                          width: 24,
                          height: 24,
                        ),
                  )
                : const SizedBox(
                    width: 24,
                    height: 24,
                  ),
            Flexible(
              child: BlocBuilder<CurrentServiceCubit, ServiceType>(
                builder: (context, currentServiceType) {
                  return Column(
                    children: [
                      Text(
                        title,
                        style: h2SbWhiteStyle,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        currentServiceType.nameRepresent,
                        style: h4Style,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
            rightTap != null
                ? GestureDetector(
                    onTap: rightTap,
                    child: SvgPicture.asset(
                      'assets/icons/logout.svg',
                      width: 24,
                      height: 24,
                    ),
                  )
                : const SizedBox(
                    width: 24,
                    height: 24,
                  ),
          ]),
    );
  }
}
