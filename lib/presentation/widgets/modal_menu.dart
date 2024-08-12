import 'package:flutter/material.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/presentation/widgets/upload_menu_item.dart';

class ModalMenuItem {
  final String title;
  final Widget icon;
  final Function() onTap;

  ModalMenuItem({required this.title, required this.icon, required this.onTap});
}

class ModalMenu extends StatelessWidget {
  final String title;
  final List<ModalMenuItem> items;

  const ModalMenu({Key? key, required this.title, required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            decoration: const BoxDecoration(
                color: extractorColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8, bottom: 24),
                child: Center(
                    child: Container(
                  width: 60,
                  height: 4,
                  decoration: const BoxDecoration(
                      color: Color(0xFF040C50),
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                )),
              ),
              Text(
                title,
                style: h2SbWhiteStyle,
                textAlign: TextAlign.left,
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: accentColor,
                margin: const EdgeInsets.symmetric(vertical: 16),
              ),
              ...items
                  .map((it) => Column(
                        children: [
                          UploadMenuItem(
                            title: it.title,
                            icon: it.icon,
                            onTap: it.onTap,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 68,
                            height: 1,
                            margin: const EdgeInsets.only(left: 40),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: optionalColor))),
                          ),
                        ],
                      ))
                  .toList(),
            ]),
          ),
        ],
      ),
    );
  }
}
