import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/hive/hive_types.dart';
import 'package:zeusfile/presentation/widgets/file_icon.dart';
import 'package:zeusfile/utils/represent_utils.dart';

class DownloadedFileItem extends StatelessWidget {
  final DownloadedFile downloadedFile;
  final String? iconPath;
  final String? menuIconPath;
  final bool allowToDelete;
  final Function()? onTap;
  final Function()? onMenuTap;
  final Function()? onDeleteButtonTap;

  const DownloadedFileItem(
      {Key? key,
      required this.downloadedFile,
      this.iconPath,
      this.menuIconPath,
      this.onTap,
      this.onMenuTap,
      this.allowToDelete = false,
      this.onDeleteButtonTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: optionalColor, shape: BoxShape.circle),
            child: Center(
                child: FileIcon(
              fileType: downloadedFile.fileType,
              iconPath: iconPath,
            )),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // ignore: unnecessary_string_interpolations
                  '${downloadedFile.fileName}',
                  style: h3RStyle,
                ),
                Row(
                  children: [
                    Text(
                      downloadedFile.size.fileSizeRepresentInMb,
                      style: h4MenuStyle,
                    ),
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(left: 8, right: 8),
                      decoration: const BoxDecoration(
                          color: menuTextColor,
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                    ),
                    Text(
                      downloadedFile.dateTime.dateOnlyLocalRepresent,
                      style: h4MenuStyle,
                    )
                  ],
                )
              ],
            ),
          ),
          if (allowToDelete)
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onDeleteButtonTap,
                child: SvgPicture.asset(
                  'assets/icons/remove_icon.svg',
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          menuIconPath != null
              ? GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onMenuTap,
                  child: SvgPicture.asset(
                    menuIconPath!,
                    width: 24,
                    height: 24,
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
