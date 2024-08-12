import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeusfile/constants.dart';

class TextFieldAccount extends StatefulWidget {
  const TextFieldAccount(
      {Key? key,
      required this.iconPath,
      this.controller,
      this.label,
      this.disabled})
      : super(key: key);

  final String iconPath;
  final TextEditingController? controller;
  final String? label;
  final bool? disabled;

  @override
  State<TextFieldAccount> createState() => _TextFieldAccountState();
}

class _TextFieldAccountState extends State<TextFieldAccount> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            widget.iconPath,
            width: 24,
            height: 24,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 88,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.only(bottom: 8),
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: optionalColor))),
            child: TextField(
                controller: widget.controller,
                enabled: widget.disabled != true,
                style: h3RStyle,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    isDense: true,
                    errorText: widget.label,
                    errorStyle: h4MenuStyle,
                    errorMaxLines: 1,
                    alignLabelWithHint: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    errorBorder: InputBorder.none)),
          ),
        ],
      ),
    );
  }
}
