import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zeusfile/data/hive/hive_types.dart';

class FileIcon extends StatelessWidget {
  final FileType fileType;
  final String? iconPath;

  final double width;
  final double height;

  static const defaultIcon = 'assets/icons/file_icon.svg';
  static const musicIcon = 'assets/icons/file_music.svg';
  static const videoIcon = 'assets/icons/file_video.svg';
  static const pdfIcon = 'assets/icons/file_pdf.svg';
  static const imageIcon = 'assets/icons/file_image.svg';
  static const documentIcon = 'assets/icons/file_document.svg';

  static const Map<FileType, String> iconMap = {
    FileType.file: defaultIcon,
    FileType.music: musicIcon,
    FileType.video: videoIcon,
    FileType.pdf: pdfIcon,
    FileType.document: documentIcon,
    FileType.image: imageIcon,
  };

  const FileIcon(
      {Key? key,
      required this.fileType,
      this.iconPath,
      this.width = 24,
      this.height = 24})
      : super(key: key);

  String get fileIconPath => iconMap[fileType] ?? defaultIcon;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
        iconPath ?? fileIconPath,
        width: width,
        height: height,
      );
}
