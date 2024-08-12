import 'package:flutter/material.dart';
import 'package:zeusfile/constants.dart';

class ButtonApp extends StatelessWidget {
  final String text;
  final Color color;
  final TextStyle textStyle;
  final Color? borderColor;
  final Function()? onTap;
  final Function()? onDisabledTap;
  final bool? disabled;
  final TextStyle? disabledTextStyle;
  final Color? disabledColor;
  final Color? disabledBorderColor;

  const ButtonApp(
      {Key? key,
      required this.text,
      this.textStyle = h2SbStyle,
      required this.color,
      this.onTap,
      this.onDisabledTap,
      this.borderColor,
      this.disabled,
      this.disabledBorderColor,
      this.disabledColor,
      this.disabledTextStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled == true ? onDisabledTap ?? () {} : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
            color: disabled == true
                ? disabledColor ?? color.withOpacity(0.4)
                : color,
            border: Border.all(
                color: disabled == true
                    ? disabledBorderColor ?? borderColor ?? color
                    : borderColor ?? color),
            borderRadius: const BorderRadius.all(Radius.circular(23))),
        child: Center(
            child: Text(text,
                style: disabled == true
                    ? disabledTextStyle ?? textStyle
                    : textStyle)),
      ),
    );
  }
}
