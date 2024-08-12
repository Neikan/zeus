import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/presentation/widgets/button_app.dart';
import 'package:zeusfile/presentation/widgets/header_app.dart';
import 'package:zeusfile/presentation/widgets/popup_item.dart';
import 'package:zeusfile/presentation/widgets/text_field_app.dart';
import 'package:zeusfile/utils/validators.dart';

enum RenameTypes { file, folder }

class RenameScreenArguments {
  final RenameTypes type;
  final String name;

  RenameScreenArguments({required this.type, required this.name});
}

class RenameScreen extends StatefulWidget {
  static const routeName = '/rename';

  const RenameScreen({Key? key}) : super(key: key);

  @override
  State<RenameScreen> createState() => _RenameScreenState();
}

class _RenameScreenState extends State<RenameScreen> {
  bool validateData = false;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final args =
          ModalRoute.of(context)!.settings.arguments as RenameScreenArguments;

      _nameController.text = args.name;

      _nameController.addListener(() {
        setState(() {
          validateData = _nameController.text.trim().length > 1 &&
              _nameController.text.trim().length < 37 &&
              fileNameValidate(_nameController.text.trim());
        });
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as RenameScreenArguments;

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
                title: args.type == RenameTypes.folder
                    ? 'Rename folder'
                    : 'Rename file',
                leftTap: () {
                  Navigator.of(context).pop('');
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
                          child: Text(
                            args.type == RenameTypes.folder
                                ? 'Enter a new\nfolder name'
                                : 'Enter a new\nfile name',
                            style: h1Style,
                          ),
                        ),
                        TextFieldApp(
                          label: args.type == RenameTypes.folder
                              ? 'Folder name'
                              : 'File name',
                          hint: args.type == RenameTypes.folder
                              ? 'Enter a new folder name'
                              : 'Enter a new file name',
                          controller: _nameController,
                        ),
                        const Padding(padding: EdgeInsets.only(top: 32)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 22,
                              child: ButtonApp(
                                text: 'Cancel',
                                onTap: () {
                                  Navigator.of(context).pop('');
                                },
                                color: mainBackColor,
                                borderColor: accentColor,
                                textStyle: h2SbWhiteStyle,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 22,
                              child: ButtonApp(
                                text: 'Rename',
                                disabled: !validateData,
                                onDisabledTap: () {
                                  FToast().removeQueuedCustomToasts();
                                  FToast().showToast(
                                      gravity: ToastGravity.TOP,
                                      toastDuration: const Duration(seconds: 3),
                                      child: PopUpItem(
                                        text: 'Invalid file name',
                                        onTap: () {
                                          FToast().removeQueuedCustomToasts();
                                        },
                                      ));
                                },
                                onTap: () {
                                  Navigator.of(context)
                                      .pop(_nameController.text);
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
                          margin: const EdgeInsets.only(bottom: 40),
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
