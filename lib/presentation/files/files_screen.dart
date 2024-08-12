// ignore_for_file: use_build_context_synchronously

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/downloaded_files_cubit/downloaded_files_cubit.dart';
import 'package:zeusfile/data/files/files_rest.dart';
import 'package:zeusfile/data/hive/hive_types.dart';
import 'package:zeusfile/data/statuses_cubit/current_service_cubit.dart';
import 'package:zeusfile/data/statuses_cubit/network_status_cubit.dart';
import 'package:zeusfile/presentation/account/logout_screen.dart';
import 'package:zeusfile/presentation/authorization/bloc/auth_bloc.dart';
import 'package:zeusfile/presentation/files/bloc/files_bloc.dart';
import 'package:zeusfile/presentation/files/remove_screen.dart';
import 'package:zeusfile/presentation/files/rename_screen.dart';
import 'package:zeusfile/presentation/main/cubit/main_screen_page_index_cubit.dart';
import 'package:zeusfile/presentation/upload/select_files_screen.dart';
import 'package:zeusfile/presentation/widgets/button_app.dart';
import 'package:zeusfile/presentation/widgets/file_item.dart';
import 'package:zeusfile/presentation/widgets/header_app.dart';
import 'package:zeusfile/presentation/widgets/media_player.dart';
import 'package:zeusfile/presentation/widgets/modal_menu.dart';
import 'package:zeusfile/presentation/widgets/popup_item.dart';
import 'package:zeusfile/presentation/widgets/service_chooser_bottom_sheet.dart';
import 'package:zeusfile/presentation/widgets/text_field_app.dart';
import 'package:zeusfile/utils/enums.dart';
import 'package:zeusfile/utils/validators.dart';

class FilesScreen extends StatefulWidget {
  const FilesScreen({Key? key}) : super(key: key);

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  List<String> selectedFiles = [];
  List<String> selectedFolders = [];

  TextEditingController folderNameController = TextEditingController();
  TextEditingController searchFilesController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  bool isFolderNameCorrect = false;

  ServiceType get currentServiceType =>
      context.read<CurrentServiceCubit>().state;

  ServiceAuth get currentServiceAuth =>
      (context.read<AuthBloc>().state is CheckedAuthState)
          ? (context.read<AuthBloc>().state as CheckedAuthState)
              .getServiceAuth(serviceType: currentServiceType)
          : context.read<AuthBloc>().state.filejokerServiceAuth;

  String get currentServiceAuthSession => currentServiceAuth.session ?? '';

  @override
  void initState() {
    super.initState();

    folderNameController.addListener(() {
      setState(() {
        isFolderNameCorrect =
            fileNameValidate(folderNameController.text.trim());
      });
    });

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        final filesBloc = BlocProvider.of<FilesBloc>(context);
        if (filesBloc.state.pagination == false &&
            filesBloc.state.pages > filesBloc.state.currentPage) {
          filesBloc.add(GetFiles(
              session: currentServiceAuthSession,
              folder: filesBloc.state.selectedFolder.isNotEmpty
                  ? filesBloc.state.selectedFolder.last
                  : null,
              isPaginate: true,
              serviceType: currentServiceType));
        }
      }
    });

    searchFilesController.addListener(
      () => setState(() {}),
    );
  }

  Future<void> _onRefresh() async {
    final filesBloc = BlocProvider.of<FilesBloc>(context);
    filesBloc.add(GetFiles(
        session: currentServiceAuthSession,
        folder: filesBloc.state.selectedFolder.isNotEmpty
            ? filesBloc.state.selectedFolder.last
            : null,
        isPaginate: false,
        serviceType: currentServiceType));
  }

  @override
  void dispose() {
    folderNameController.removeListener(() {});
    folderNameController.dispose();
    searchFilesController.removeListener(() {});
    searchFilesController.dispose();
    _scrollController.removeListener(() {});
    _scrollController.dispose();
    super.dispose();
  }

  List<ModalMenuItem>? getWatchModalMenuItem({required FileObject userFile}) {
    final fileTypeByExtension =
        FileType.file.getFileTypeByExtension(userFile.name);

    if (fileTypeByExtension != FileType.music &&
        fileTypeByExtension != FileType.video) return null;

    return [
      ModalMenuItem(
          title: fileTypeByExtension.callToActionRepresent,
          icon: SvgPicture.asset(
            'assets/icons/file_video.svg',
            width: 24,
            height: 24,
          ),
          onTap: () async {
            final downloadedFilesCubit = context.read<DownloadedFilesCubit>();
            final downloadUrl = await downloadedFilesCubit.getDownloadUrl(
              serviceType: currentServiceType,
              session: currentServiceAuthSession,
              url: userFile.url(currentServiceType),
            );
            Navigator.of(context).pop();

            if (downloadUrl == null) return;

            MediaPlayer.dialog(context,
                sourceUrl: downloadUrl, fileType: fileTypeByExtension);
          })
    ];
  }

  void showFileMenu({required FileObject userFile}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return ModalMenu(
            title: 'File: ${userFile.name}',
            items: [
              ModalMenuItem(
                  title: 'Rename',
                  icon: SvgPicture.asset(
                    'assets/icons/rename_file_icon.svg',
                    width: 24,
                    height: 24,
                  ),
                  onTap: () async {
                    final newName = await Navigator.of(context).pushNamed(
                        RenameScreen.routeName,
                        arguments: RenameScreenArguments(
                            type: RenameTypes.file, name: userFile.name));
                    if (newName != null &&
                        newName is String &&
                        newName.trim().isNotEmpty) {
                      BlocProvider.of<FilesBloc>(context).add(RenameFile(
                          session: currentServiceAuthSession,
                          fileCode: userFile.code,
                          fileName: newName,
                          serviceType: currentServiceType));
                      Navigator.of(context).pop();
                    }
                  }),
              ModalMenuItem(
                  title: 'Move',
                  icon: SvgPicture.asset(
                    'assets/icons/move_file_icon.svg',
                    width: 24,
                    height: 24,
                  ),
                  onTap: () async {
                    final selectedFolder = await Navigator.of(context)
                        .pushNamed(SelectFilesScreen.routeName);
                    if (selectedFolder != null) {
                      BlocProvider.of<FilesBloc>(context).add(MoveFile(
                          session: currentServiceAuthSession,
                          fileCode: userFile.code,
                          folderId: int.parse((selectedFolder as String)),
                          serviceType: currentServiceType));
                      Navigator.of(context).pop();
                    }
                  }),
              ModalMenuItem(
                  title: 'Download',
                  icon: SvgPicture.asset(
                    'assets/icons/download.svg',
                    width: 24,
                    height: 24,
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return ModalMenu(
                            title: 'Select an action',
                            items: [
                              ModalMenuItem(
                                  title: 'Download file',
                                  icon: SvgPicture.asset(
                                    'assets/icons/download.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                  onTap: () async {
                                    final downloadedFilesCubit =
                                        context.read<DownloadedFilesCubit>();
                                    // BlocProvider.of<DownloadBloc>(context).add(DownloadServer(session: currentServiceAuthSession, fileCode: userFile.code, isDownload: true));
                                    final result = await downloadedFilesCubit
                                        .addDownloadFile(
                                            serviceType: currentServiceType,
                                            url: userFile
                                                .url(currentServiceType),
                                            session: currentServiceAuthSession);

                                    Navigator.of(context).pop();

                                    if (result) {
                                      context
                                          .read<MainScreenPageIndexCubit>()
                                          .setPageIndex(pageIndex: 2);
                                    }
                                  }),
                              ModalMenuItem(
                                title: 'Copy link to clipboard',
                                icon: SvgPicture.asset(
                                  'assets/icons/clipboard_icon.svg',
                                  width: 24,
                                  height: 24,
                                ),
                                onTap: () => FlutterClipboard.copy(
                                        userFile.url(currentServiceType))
                                    .then((value) {
                                  FToast().removeQueuedCustomToasts();
                                  FToast().showToast(
                                      gravity: ToastGravity.TOP,
                                      toastDuration: const Duration(seconds: 3),
                                      child: PopUpItem(
                                        text: 'Link copied to clipboard',
                                        textStyle: h2SbStyle,
                                        onTap: () {
                                          FToast().removeQueuedCustomToasts();
                                        },
                                      ));
                                  Navigator.of(context).pop();
                                }),
                              ),
                            ],
                          );
                        });
                  }),
              ...?getWatchModalMenuItem(userFile: userFile),
              ModalMenuItem(
                title: 'Delete',
                icon: SvgPicture.asset(
                  'assets/icons/delete_file_icon.svg',
                  width: 24,
                  height: 24,
                ),
                onTap: () async {
                  final result = await Navigator.of(context)
                      .pushNamed(RemoveScreen.routeName);

                  if (result == true) {
                    BlocProvider.of<FilesBloc>(context).add(DeleteFile(
                        session: currentServiceAuthSession,
                        fileCode: userFile.code,
                        serviceType: currentServiceType));
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackColor,
      body: BlocBuilder<CurrentServiceCubit, ServiceType>(
        builder: (context, currentServiceType) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Stack(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: Column(
                      children: [
                        HeaderApp(
                          title: 'My Files',
                          leftIcon: SvgPicture.asset(
                            'assets/icons/check_service_icon.svg',
                            width: 24,
                            height: 24,
                          ),
                          leftTap: () =>
                              ServiceChooserBottomSheet.changeService(context),
                          rightTap: () => Navigator.of(context).push(
                              LogoutScreen.materialPageRoute(
                                  serviceType: currentServiceType)),
                        ),
                        BlocListener<FilesBloc, FilesState>(
                          listener: (ctx, state) {
                            // TODO remove?
                            // if (state.status == NetworkStatus.success) {
                            //   folderNameController.text = '';
                            // }
                          },
                          child: Flexible(
                              child: RefreshIndicator(
                            onRefresh: _onRefresh,
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _scrollController,
                              child: Column(children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  margin: const EdgeInsets.only(bottom: 24),
                                  child: TextFieldApp(
                                    hint: 'Search',
                                    controller: searchFilesController,
                                    borderColor: deepBlueColor,
                                    backColor: deepBlueColor,
                                    icon: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: SvgPicture.asset(
                                        'assets/icons/search_icon.svg',
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                    40) *
                                                0.66,
                                        child: TextFieldApp(
                                          hint: 'Enter new folder name',
                                          label: 'Folder name',
                                          borderColor: deepBlueColor,
                                          backColor: deepBlueColor,
                                          controller: folderNameController,
                                        ),
                                      ),
                                      BlocBuilder<FilesBloc, FilesState>(
                                          builder: (context, filesBlocState) =>
                                              SizedBox(
                                                  width: (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          40) *
                                                      0.33,
                                                  child: ButtonApp(
                                                    text: 'Create',
                                                    color: mainBackColor,
                                                    borderColor: accentColor,
                                                    textStyle: h2SbWhiteStyle,
                                                    disabledTextStyle:
                                                        h2SbAzureStyle,
                                                    disabledBorderColor:
                                                        azureColor,
                                                    disabled:
                                                        !isFolderNameCorrect,
                                                    onTap: () {
                                                      BlocProvider.of<FilesBloc>(context).add(CreateFolder(
                                                          session: currentServiceAuth
                                                                  .session ??
                                                              '',
                                                          folderName:
                                                              folderNameController
                                                                  .text
                                                                  .trim(),
                                                          serviceType:
                                                              currentServiceType,
                                                          parentFolderId: filesBlocState
                                                                  .selectedFolder
                                                                  .isNotEmpty
                                                              ? filesBlocState
                                                                  .selectedFolder
                                                                  .last
                                                                  .parentId
                                                              : null));
                                                      // TODO may be check before clean
                                                      folderNameController
                                                          .text = '';
                                                    },
                                                  )))
                                    ],
                                  ),
                                ),
                                BlocBuilder<FilesBloc, FilesState>(
                                    builder: (context, filesBlocState) {
                                  if (filesBlocState.selectedFolder.isEmpty) {
                                    return Container();
                                  }

                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    width:
                                        MediaQuery.of(context).size.width - 32,
                                    height: 36,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              BlocProvider.of<FilesBloc>(
                                                      context)
                                                  .add(GetFiles(
                                                      session:
                                                          currentServiceAuth
                                                                  .session ??
                                                              '',
                                                      serviceType:
                                                          currentServiceType));
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(24)),
                                                  color: azureColor),
                                              child: SvgPicture.asset(
                                                'assets/icons/back_icon.svg',
                                                width: 20,
                                                height: 20,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 30,
                                                right: 30,
                                                top: 6,
                                                bottom: 6),
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(24)),
                                                color: azureColor),
                                            child: Row(
                                              children: [
                                                Text(
                                                  filesBlocState
                                                      .selectedFolder.last.name,
                                                  style: h4Style,
                                                ),
                                                // Container(
                                                //   margin: const EdgeInsets.only(
                                                //       left: 4),
                                                //   child: SvgPicture.asset(
                                                //     'assets/icons/arrow_right.svg',
                                                //     width: 20,
                                                //     height: 20,
                                                //   ),
                                                // )
                                              ],
                                            ),
                                          ),
                                        ]),
                                  );
                                }),
                                selectedFolders.isNotEmpty
                                    ? Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 16),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedFolders = [];
                                                      });
                                                    },
                                                    child: SvgPicture.asset(
                                                      'assets/icons/close_icon.svg',
                                                      width: 24,
                                                      height: 24,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 12),
                                                    child: Text(
                                                      '${selectedFolders.length} folder selected',
                                                      style: h2SbWhiteStyle,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              GestureDetector(
                                                behavior:
                                                    HitTestBehavior.opaque,
                                                onTap: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      builder: (context) {
                                                        return ModalMenu(
                                                          title:
                                                              '${selectedFolders.length} folder selected',
                                                          items: [
                                                            ModalMenuItem(
                                                              title: 'Delete',
                                                              icon: SvgPicture
                                                                  .asset(
                                                                'assets/icons/delete_file_icon.svg',
                                                                width: 24,
                                                                height: 24,
                                                              ),
                                                              onTap: () async {
                                                                final result = await Navigator.of(
                                                                        context)
                                                                    .pushNamed(
                                                                        RemoveScreen
                                                                            .routeName);

                                                                if (result ==
                                                                    true) {
                                                                  BlocProvider.of<FilesBloc>(context).add(DeleteFolder(
                                                                      session:
                                                                          currentServiceAuthSession,
                                                                      folderId:
                                                                          selectedFolders.join(
                                                                              ','),
                                                                      serviceType:
                                                                          currentServiceType));
                                                                  setState(() {
                                                                    selectedFolders =
                                                                        [];
                                                                  });
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: SvgPicture.asset(
                                                  'assets/icons/more_icon.svg',
                                                  width: 24,
                                                  height: 24,
                                                ),
                                              ),
                                            ]),
                                      )
                                    // TODO Remove?
                                    // : Container(
                                    //     margin: const EdgeInsets.symmetric(
                                    //         horizontal: 24, vertical: 16),
                                    //     child: Row(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.spaceBetween,
                                    //         children: [
                                    //           Row(
                                    //             children: [
                                    //               GestureDetector(
                                    //                 onTap: () {
                                    //                   final folders = BlocProvider
                                    //                           .of<FilesBloc>(
                                    //                               context)
                                    //                       .state
                                    //                       .userFiles
                                    //                       ?.folders
                                    //                       .map((e) => e.id);

                                    //                   setState(() {
                                    //                     selectedFolders =
                                    //                         folders?.toList() ?? [];
                                    //                   });
                                    //                 },
                                    //                 child: SvgPicture.asset(
                                    //                   'assets/icons/checkbox.svg',
                                    //                   width: 24,
                                    //                   height: 24,
                                    //                 ),
                                    //               ),
                                    //               Container(
                                    //                 margin: const EdgeInsets.only(
                                    //                     left: 12),
                                    //                 child: const Text(
                                    //                   'Folder name',
                                    //                   style: h2SbWhiteStyle,
                                    //                 ),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ]),
                                    //   ),
                                    : Container(),
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(
                                      left: 16, right: 16, bottom: 16),
                                  color: accentColor,
                                ),
                                BlocBuilder<FilesBloc, FilesState>(
                                    builder: ((context, filesBlocState) {
                                  return Column(
                                    children: filesBlocState.userFiles?.folders
                                            .map(
                                              (e) => FileItem(
                                                name: e.name,
                                                onCheckTap: () {
                                                  if (selectedFolders
                                                      .contains(e.id)) {
                                                    final newFolders =
                                                        selectedFolders
                                                            .where((element) =>
                                                                element != e.id)
                                                            .toList();
                                                    setState(() {
                                                      selectedFolders =
                                                          newFolders;
                                                    });
                                                  } else {
                                                    final newFolders = [
                                                      ...selectedFolders,
                                                      e.id
                                                    ];

                                                    setState(() {
                                                      selectedFolders =
                                                          newFolders;
                                                    });
                                                  }
                                                },
                                                onTap: () {
                                                  BlocProvider.of<FilesBloc>(
                                                          context)
                                                      .add(GetFiles(
                                                          session:
                                                              currentServiceAuth
                                                                      .session ??
                                                                  '',
                                                          folder: e,
                                                          serviceType:
                                                              currentServiceType));
                                                },
                                                onMenuTap: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      builder: (context) {
                                                        return ModalMenu(
                                                          title:
                                                              'Folder: ${e.name}',
                                                          items: [
                                                            ModalMenuItem(
                                                                title: 'Rename',
                                                                icon: SvgPicture
                                                                    .asset(
                                                                  'assets/icons/rename_file_icon.svg',
                                                                  width: 24,
                                                                  height: 24,
                                                                ),
                                                                onTap:
                                                                    () async {
                                                                  final newName = await Navigator.of(context).pushNamed(
                                                                      RenameScreen
                                                                          .routeName,
                                                                      arguments: RenameScreenArguments(
                                                                          type: RenameTypes
                                                                              .folder,
                                                                          name:
                                                                              e.name));
                                                                  if (newName !=
                                                                          null &&
                                                                      newName
                                                                          is String &&
                                                                      newName
                                                                          .trim()
                                                                          .isNotEmpty) {
                                                                    BlocProvider.of<FilesBloc>(context).add(RenameFolder(
                                                                        session:
                                                                            currentServiceAuthSession,
                                                                        folderId:
                                                                            int.parse(e
                                                                                .id),
                                                                        folderName:
                                                                            newName,
                                                                        serviceType:
                                                                            currentServiceType));
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  }
                                                                }),
                                                            ModalMenuItem(
                                                              title: 'Delete',
                                                              icon: SvgPicture
                                                                  .asset(
                                                                'assets/icons/delete_file_icon.svg',
                                                                width: 24,
                                                                height: 24,
                                                              ),
                                                              onTap: () async {
                                                                final result = await Navigator.of(
                                                                        context)
                                                                    .pushNamed(
                                                                        RemoveScreen
                                                                            .routeName);

                                                                if (result ==
                                                                    true) {
                                                                  BlocProvider.of<FilesBloc>(context).add(DeleteFolder(
                                                                      session:
                                                                          currentServiceAuth.session ??
                                                                              '',
                                                                      folderId:
                                                                          e.id,
                                                                      serviceType:
                                                                          currentServiceType));
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                isSelected: selectedFolders
                                                    .contains(e.id),
                                                iconPath:
                                                    'assets/icons/folder_icon.svg',
                                              ),
                                            )
                                            .toList() ??
                                        [],
                                  );
                                })),
                                selectedFiles.isNotEmpty
                                    ? Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 24, vertical: 16),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedFiles = [];
                                                      });
                                                    },
                                                    child: SvgPicture.asset(
                                                      'assets/icons/close_icon.svg',
                                                      width: 24,
                                                      height: 24,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 12),
                                                    child: Text(
                                                      '${selectedFiles.length} file selected',
                                                      style: h2SbWhiteStyle,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              GestureDetector(
                                                behavior:
                                                    HitTestBehavior.opaque,
                                                onTap: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      builder: (context) {
                                                        return ModalMenu(
                                                          title:
                                                              '${selectedFiles.length} file selected',
                                                          items: [
                                                            ModalMenuItem(
                                                                title: 'Move',
                                                                icon: SvgPicture
                                                                    .asset(
                                                                  'assets/icons/move_file_icon.svg',
                                                                  width: 24,
                                                                  height: 24,
                                                                ),
                                                                onTap:
                                                                    () async {
                                                                  final selectedFolder = await Navigator.of(
                                                                          context)
                                                                      .pushNamed(
                                                                          SelectFilesScreen
                                                                              .routeName);
                                                                  if (selectedFolder !=
                                                                      null) {
                                                                    BlocProvider.of<FilesBloc>(context).add(MoveFile(
                                                                        session:
                                                                            currentServiceAuthSession,
                                                                        fileCode:
                                                                            selectedFiles.join(
                                                                                ','),
                                                                        folderId:
                                                                            int.parse((selectedFolder
                                                                                as String)),
                                                                        serviceType:
                                                                            currentServiceType));
                                                                    setState(
                                                                        () {
                                                                      selectedFiles =
                                                                          [];
                                                                    });
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  }
                                                                }),
                                                            ModalMenuItem(
                                                              title: 'Delete',
                                                              icon: SvgPicture
                                                                  .asset(
                                                                'assets/icons/delete_file_icon.svg',
                                                                width: 24,
                                                                height: 24,
                                                              ),
                                                              onTap: () async {
                                                                final result = await Navigator.of(
                                                                        context)
                                                                    .pushNamed(
                                                                        RemoveScreen
                                                                            .routeName);

                                                                if (result ==
                                                                    true) {
                                                                  BlocProvider.of<FilesBloc>(context).add(DeleteFile(
                                                                      session:
                                                                          currentServiceAuthSession,
                                                                      fileCode:
                                                                          selectedFiles.join(
                                                                              ','),
                                                                      serviceType:
                                                                          currentServiceType));
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: SvgPicture.asset(
                                                  'assets/icons/more_icon.svg',
                                                  width: 24,
                                                  height: 24,
                                                ),
                                              ),
                                            ]),
                                      )
                                    // TODO remove?
                                    // : Container(
                                    //     margin: const EdgeInsets.symmetric(
                                    //         horizontal: 24, vertical: 16),
                                    //     child: Row(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.spaceBetween,
                                    //         children: [
                                    //           Row(
                                    //             children: [
                                    //               GestureDetector(
                                    //                 onTap: () {
                                    //                   final files = BlocProvider.of<
                                    //                           FilesBloc>(context)
                                    //                       .state
                                    //                       .userFiles
                                    //                       ?.files
                                    //                       .map((e) => e.code);

                                    //                   setState(() {
                                    //                     selectedFiles =
                                    //                         files?.toList() ?? [];
                                    //                   });
                                    //                 },
                                    //                 child: SvgPicture.asset(
                                    //                   'assets/icons/checkbox.svg',
                                    //                   width: 24,
                                    //                   height: 24,
                                    //                 ),
                                    //               ),
                                    //               Container(
                                    //                 margin: const EdgeInsets.only(
                                    //                     left: 12),
                                    //                 child: const Text(
                                    //                   'File name',
                                    //                   style: h2SbWhiteStyle,
                                    //                 ),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ]),
                                    //   ),
                                    : Container(
                                        height: 16,
                                      ),
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(
                                      left: 16, right: 16, bottom: 16),
                                  color: accentColor,
                                ),
                                BlocBuilder<FilesBloc, FilesState>(
                                    builder: ((context, fileBlocState) {
                                  return Column(
                                    children: [
                                      ...fileBlocState
                                          .searchFiles(
                                              fileName:
                                                  searchFilesController.text)
                                          .map(
                                            (userFile) => FileItem(
                                              name: userFile.name,
                                              size:
                                                  // TODO change files size to MB parser
                                                  '${((double.tryParse(userFile.size) ?? 0) / 1000000).toStringAsFixed(2)} Mb',
                                              created: userFile.createdDateTime,
                                              isSelected: selectedFiles
                                                  .contains(userFile.code),
                                              onTap: () {
                                                showFileMenu(
                                                    userFile: userFile);
                                              },
                                              onCheckTap: () {
                                                if (selectedFiles
                                                    .contains(userFile.code)) {
                                                  final newFiles = selectedFiles
                                                      .where((element) =>
                                                          element !=
                                                          userFile.code)
                                                      .toList();
                                                  setState(() {
                                                    selectedFiles = newFiles;
                                                  });
                                                } else {
                                                  final newFiles = [
                                                    ...selectedFiles,
                                                    userFile.code
                                                  ];

                                                  setState(() {
                                                    selectedFiles = newFiles;
                                                  });
                                                }
                                              },
                                              onMenuTap: () {
                                                showFileMenu(
                                                    userFile: userFile);
                                              },
                                              iconPath:
                                                  'assets/icons/file_icon_screen.svg',
                                            ),
                                          )
                                          .toList(),
                                      fileBlocState.pagination == true
                                          ? Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  32,
                                              child: const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            )
                                          : Container()
                                    ],
                                  );
                                })),
                              ]),
                            ),
                          )),
                        ),
                      ],
                    )),
                BlocBuilder<NetworkStatusCubit, NetworkStatus>(
                    builder: (context, state) =>
                        (state == NetworkStatus.loading)
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              )
                            : Container())
              ],
            ),
          );
        },
      ),
    );
  }
}
