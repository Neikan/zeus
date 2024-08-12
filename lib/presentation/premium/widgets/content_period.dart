import 'package:flutter/material.dart';
import 'package:zeusfile/constants.dart';

class ContentPeriod extends StatelessWidget {
  final String text;
  final bool checkBoxBool;
  final bool alredyBought;
  final Function(bool value) onChanged;

  const ContentPeriod(
      {super.key,
      required this.text,
      required this.alredyBought,
      this.checkBoxBool = false,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: optionalColor))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          height: 20,
          width: 20,
          decoration: const BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Checkbox(
            value: checkBoxBool,
            onChanged: (value) => onChanged(value!),
            activeColor: accentColor,
            shape: const CircleBorder(),
            side: BorderSide(
                width: 0.5,
                color: checkBoxBool ? whiteBaseColor : menuTextColor),
            checkColor: extractorColor,
          ),
        ),
        const SizedBox(width: 15),
        Text(
          text,
          style: h3RStyle,
        ),
        alredyBought
            ? const Text(
                ' (alredy bought)',
                style: h3SbStyle,
              )
            : Container()
      ]),
    );
  }
}
