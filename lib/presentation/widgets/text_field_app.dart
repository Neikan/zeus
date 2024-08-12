import 'package:flutter/material.dart';
import 'package:zeusfile/constants.dart';

class TextFieldApp extends StatelessWidget {
  final String? label;
  final String? hint;
  final Widget? icon;
  final bool? obscure;
  final TextEditingController? controller;
  final Color? borderColor;
  final Color? backColor;
  final bool? disabled;
  final TextInputType? textInputType;
  final int? maxLines;

  const TextFieldApp(
      {Key? key,
      this.label,
      this.hint,
      this.icon,
      this.obscure,
      this.controller,
      this.borderColor,
      this.backColor,
      this.disabled,
      this.textInputType,
      this.maxLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: disabled == null ? true : !disabled!,
      controller: controller,
      style: h3RStyle,
      obscureText: obscure ?? false,
      keyboardType: textInputType,
      maxLines: maxLines,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
          suffixIcon: icon,
          suffixIconConstraints:
              const BoxConstraints(maxHeight: 40, maxWidth: 40),
          labelText: label,
          labelStyle: h4Style,
          hintText: hint,
          hintStyle: h4Style,
          filled: backColor != null,
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              borderSide: BorderSide(color: borderColor ?? lavenderColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              borderSide: BorderSide(color: borderColor ?? lavenderColor)),
          disabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              borderSide: BorderSide(color: borderColor ?? lavenderColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              borderSide: BorderSide(color: borderColor ?? lavenderColor)),
          focusColor: extractorColor,
          fillColor: backColor),
    );
  }
}
