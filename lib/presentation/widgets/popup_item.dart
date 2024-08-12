import 'package:flutter/material.dart';
import 'package:zeusfile/constants.dart';

class PopUpItem extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final TextStyle? textStyle;

  const PopUpItem(
      {super.key, required this.text, this.onTap, this.textStyle = errorStyle});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(color: Colors.black, spreadRadius: 0, blurRadius: 4),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Container(
                  //   padding: EdgeInsets.only(right: 10),
                  //   child: SvgPicture.asset(
                  //     info == true
                  //         ? "assets/images/info.svg"
                  //         : error == true
                  //             ? "assets/images/error.svg"
                  //             : success == true
                  //                 ? "assets/images/success.svg"
                  //                 : '',
                  //     width: 23,
                  //     height: 23,
                  //     fit: BoxFit.fitWidth,
                  //   ),
                  // ),
                  Expanded(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: textStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
