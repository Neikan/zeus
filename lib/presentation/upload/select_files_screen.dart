// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/presentation/files/bloc/files_bloc.dart';
import 'package:zeusfile/presentation/widgets/button_app.dart';
import 'package:zeusfile/presentation/widgets/folder_item.dart';
import 'package:zeusfile/presentation/widgets/header_app.dart';

class SelectFilesScreen extends StatefulWidget {
  static const routeName = '/select_files';

  const SelectFilesScreen({Key? key}) : super(key: key);

  @override
  State<SelectFilesScreen> createState() => _SelectFilesScreenState();
}

class _SelectFilesScreenState extends State<SelectFilesScreen> {
  String? selectedFolder;

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
                SizedBox(
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      78,
                  child: Column(
                    children: [
                      HeaderApp(
                        title: 'Select folder',
                        leftTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Flexible(
                          child: SingleChildScrollView(
                        child: Column(children: [
                          Container(
                            height: 1,
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 16),
                            color: accentColor,
                          ),
                          BlocBuilder<FilesBloc, FilesState>(
                              builder: ((context, state) {
                            return Column(
                              children: [
                                FolderItem(
                                    name: 'Root folder',
                                    onTap: () {
                                      setState(() {
                                        selectedFolder = '0';
                                      });
                                    },
                                    isSelected: '0' == selectedFolder,
                                    iconPath: 'assets/icons/folder_icon.svg'),
                                ...state.userFiles?.folders
                                        .map((fld) => FolderItem(
                                            name: fld.name,
                                            onTap: () {
                                              setState(() {
                                                selectedFolder = fld.id;
                                              });
                                            },
                                            isSelected:
                                                fld.id == selectedFolder,
                                            iconPath:
                                                'assets/icons/folder_icon.svg'))
                                        .toList() ??
                                    []
                              ],
                            );
                          })),
                        ]),
                      )),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 22,
                        child: ButtonApp(
                          text: 'Cancel',
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          color: mainBackColor,
                          borderColor: accentColor,
                          textStyle: h2SbWhiteStyle,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 22,
                        child: ButtonApp(
                          text: 'Move',
                          disabled: selectedFolder == null,
                          onTap: () {
                            Navigator.of(context).pop(selectedFolder);
                          },
                          color: accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
