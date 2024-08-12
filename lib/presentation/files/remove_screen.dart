import 'package:flutter/material.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/presentation/widgets/button_app.dart';
import 'package:zeusfile/presentation/widgets/header_app.dart';

class RemoveScreen extends StatelessWidget {
  static const routeName = '/remove';

  const RemoveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeaderApp(
                title: 'Delete',
                leftTap: () {
                  Navigator.of(context).pop(false);
                },
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 1,
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 16),
                          color: accentColor,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 64,
                          margin: const EdgeInsets.only(top: 44, bottom: 30),
                          child: const Text(
                            'Do you really want to remove this file?',
                            style: h1Style,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 22,
                              child: ButtonApp(
                                text: 'Cancel',
                                onTap: () {
                                  Navigator.of(context).pop(false);
                                },
                                color: mainBackColor,
                                borderColor: accentColor,
                                textStyle: h2SbWhiteStyle,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 22,
                              child: ButtonApp(
                                text: 'Delete',
                                onTap: () {
                                  Navigator.of(context).pop(true);
                                },
                                color: accentColor,
                              ),
                            ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(top: 35)),
                        Container(
                          height: 1,
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 70),
                          color: accentColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
