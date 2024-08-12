import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeusfile/constants.dart';

class PreloaderScreen extends StatefulWidget {
  const PreloaderScreen({Key? key}) : super(key: key);

  static const routeName = '/preloader';

  @override
  State<PreloaderScreen> createState() => _PreloaderScreenState();
}

class _PreloaderScreenState extends State<PreloaderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mainBackColor,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 70)),
              SvgPicture.asset(
                'assets/icons/logo.svg',
                width: 88,
                height: 81,
              ),
              const Padding(padding: EdgeInsets.only(bottom: 20)),
              const Text(
                'Zeus File Manager',
                style: h1Style,
                textAlign: TextAlign.center,
              ),
              const Padding(padding: EdgeInsets.only(bottom: 40)),
              const CircularProgressIndicator(
                color: accentColor,
                backgroundColor: optionalColor,
              )
            ],
          ),
        ));
  }
}
