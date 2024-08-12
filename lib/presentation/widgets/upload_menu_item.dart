import 'package:flutter/material.dart';
import 'package:zeusfile/constants.dart';

class UploadMenuItem extends StatelessWidget {
  final String title;
  final Widget icon;
  final Function()? onTap;

  const UploadMenuItem(
      {Key? key, required this.title, required this.icon, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(children: [
          icon,
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: Text(
              title,
              style: h3RStyle,
            ),
          )
        ]),
      ),
    );
  }
}
