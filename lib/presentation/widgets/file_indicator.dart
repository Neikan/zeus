import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeusfile/constants.dart';

class FileIndicator extends StatelessWidget {
  final double progressPercent;
  final Color color;
  final String iconAsset;
  final Function()? onTap;
  final Function()? onMenuTap;

  const FileIndicator(
      {Key? key,
      required this.progressPercent,
      this.color = accentColor,
      this.iconAsset = 'assets/icons/close.svg',
      this.onTap,
      this.onMenuTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          CircularProgressIndicator(
            value: progressPercent,
            backgroundColor: optionalColor,
            color: color,
            strokeWidth: 2,
          ),
          Positioned.fill(
            child: InkWell(
              onTap: onTap,
              child: Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  iconAsset,
                  color: color,
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
        ],
      );
}
