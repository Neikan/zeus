import 'package:hive_flutter/hive_flutter.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/hive/hive_types.dart';

class HiveRepository {
  static HiveRepository? _instance;

  static HiveRepository get instance {
    _instance ??= HiveRepository();
    return _instance!;
  }

  static Future<void> hiveInit() async {
    await Hive.initFlutter();

    Hive.registerAdapter(DownloadedFileAdapter());
    Hive.registerAdapter(DownloadedFileStatusAdapter());
    Hive.registerAdapter(ServiceTypeAdapter());

    await Hive.openBox<DownloadedFile>(hiveNotesBoxName);
  }

  factory HiveRepository.repository() => instance;

  static const hiveNotesBoxName = 'notesBox';

  late Box<DownloadedFile> hiveDownloadedFilesBox;
  Stream<BoxEvent> get hiveNotesBoxStream =>
      hiveDownloadedFilesBox.watch().asBroadcastStream();

  void clearRepository() async {
    await hiveDownloadedFilesBox.clear();
  }

  HiveRepository() {
    hiveDownloadedFilesBox = Hive.box<DownloadedFile>(hiveNotesBoxName);
  }
}
