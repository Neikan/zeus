import 'package:zeusfile/presentation/account/promocode_screen.dart';
import 'package:zeusfile/presentation/files/remove_screen.dart';
import 'package:zeusfile/presentation/files/rename_screen.dart';
import 'package:zeusfile/presentation/main/main_screen.dart';
import 'package:zeusfile/presentation/preloader/preloader_screen.dart';
import 'package:zeusfile/presentation/registration/register_screen.dart';
import 'package:zeusfile/presentation/service/services_screen.dart';
import 'package:zeusfile/presentation/upload/select_files_screen.dart';

final routes = {
  PreloaderScreen.routeName: (context) => const PreloaderScreen(),
  ServicesScreen.routeName: (context) => const ServicesScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
  MainScreen.routeName: (context) => const MainScreen(),
  SelectFilesScreen.routeName: (context) => const SelectFilesScreen(),
  RemoveScreen.routeName: (context) => const RemoveScreen(),
  RenameScreen.routeName: (context) => const RenameScreen(),
  PromocodeScreen.routeName: (context) => const PromocodeScreen(),
};
