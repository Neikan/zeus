// ignore_for_file: avoid_print

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future downloadFile(Dio dio, String url, String fileName) async {
  try {
    final statusStore = await Permission.storage.status;
    if (!statusStore.isGranted) {
      final result = await Permission.storage.request();
      if (!result.isGranted) {
        return;
      }
    }
    Directory? directory;

    if (Platform.isIOS) {
      directory = await getDownloadsDirectory();
      print(directory?.path);
    } else if (Platform.isAndroid) {
      directory = await getTemporaryDirectory();
    }

    if (directory == null) {
      return;
    }

    Response response = await dio.get(url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ));

    File file = File('${directory.path}/$fileName');
    var raf = file.openSync(mode: FileMode.write);
    // response.data is List<int> type
    raf.writeFromSync(response.data);
    await raf.close();

    if (Platform.isAndroid) {
      final params =
          SaveFileDialogParams(sourceFilePath: '${directory.path}/$fileName');
      final filePath = await FlutterFileDialog.saveFile(params: params);

      print('Download path: $filePath');
    }
  } catch (e) {
    print(e);
  }
}
