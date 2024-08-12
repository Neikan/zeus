import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:zeusfile/constants.dart';

class FolderItem extends StatelessWidget {
  final String name;
  final String? size;
  final String? created;
  final String iconPath;
  final Function() onTap;
  final bool? isSelected;

  const FolderItem(
      {Key? key,
      required this.name,
      this.size,
      this.created,
      required this.onTap,
      required this.iconPath,
      this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  isSelected == true
                      ? 'assets/icons/checkbox_checked.svg'
                      : 'assets/icons/checkbox.svg',
                  width: 24,
                  height: 24,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 16, right: 8),
                  child: SvgPicture.asset(
                    iconPath,
                    width: 32,
                    height: 32,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 184,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: h3RStyle,
                      ),
                      size != null && created != null
                          ? Row(
                              children: [
                                Text(
                                  size!,
                                  style: h4Style,
                                ),
                                Container(
                                  width: 4,
                                  height: 4,
                                  margin:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  decoration: const BoxDecoration(
                                      color: menuTextColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
                                ),
                                Text(
                                  DateFormat('MMM dd, yyyy', 'en')
                                      .format(DateTime.parse(created!)),
                                  style: h4Style,
                                )
                              ],
                            )
                          : Container(),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
