import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/downloaded_files_cubit/downloaded_files_cubit.dart';
import 'package:zeusfile/data/hive/hive_types.dart';
import 'package:zeusfile/data/statuses_cubit/current_service_cubit.dart';
import 'package:zeusfile/data/statuses_cubit/network_status_cubit.dart';
import 'package:zeusfile/data/uni_links/uni_links_bloc.dart';
import 'package:zeusfile/presentation/account/logout_screen.dart';
import 'package:zeusfile/presentation/authorization/bloc/auth_bloc.dart';
import 'package:zeusfile/presentation/main/cubit/main_screen_page_index_cubit.dart';
import 'package:zeusfile/presentation/upload/bloc/upload_bloc.dart';
import 'package:zeusfile/presentation/widgets/button_app.dart';
import 'package:zeusfile/presentation/widgets/downloaded_file_item.dart';
import 'package:zeusfile/presentation/widgets/file_indicator.dart';
import 'package:zeusfile/presentation/widgets/header_app.dart';
import 'package:zeusfile/presentation/widgets/popup_item.dart';
import 'package:zeusfile/presentation/widgets/service_chooser_bottom_sheet.dart';
import 'package:zeusfile/presentation/widgets/text_field_app.dart';
import 'package:zeusfile/utils/enums.dart';
import 'package:zeusfile/utils/represent_utils.dart';
import 'package:open_filex/open_filex.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  static const initialLinks = [
    'https://filejoker.net/q0ahfl0n8rts/pdf_55mb.pdf',
    'https://filejoker.net/6szin2h5r2jt/music_128mb.mp3',
    'https://filejoker.net/wtwitr0s9x0u/music_1mb.mp3',
    'https://filejoker.net/w6x5uda9mgbm/music_3mb.mp3',
    'https://filejoker.net/b4g50m1b5wdu/music_57mb.mp3',
    'https://filejoker.net/y5cc5t9mh4uz/music_5mb.mp3',
    'https://filejoker.net/2oyx2yssr46z/pdf_101mb.pdf',
    'https://filejoker.net/z0qicihqxnai/pdf_156mb.pdf',
    'https://filejoker.net/mfqbex6qt3n1/pdf_1mb.pdf',
    'https://filejoker.net/10hccn79anvs/pdf_298mb.pdf',
    'https://filejoker.net/0nx3cooda7pa/pdf_4mb.pdf',
    'https://filejoker.net/q0ahfl0n8rts/pdf_55mb.pdf',
    'https://filejoker.net/e9gzv9k6bp1a/video_15mb.mp4',
    'https://filejoker.net/ovykyvh5isa8/video_62mb.mp4',
    'https://filejoker.net/ya9rj3h32dxx/video_847mb.mp4',
    'https://filejoker.net/qjovz93qvajx/video_6000mb.mp4',
  ];

  static String get initialLink =>
      initialLinks[Random().nextInt(initialLinks.length)];

  // TODO remove
  // final TextEditingController _urlController =
  //     TextEditingController(text: initialLink);

  // TODO restore
  final TextEditingController _urlController = TextEditingController(text: '');

  TextEditingController searchFilesController = TextEditingController();

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

    final UniLinksBloc uniLinksBloc = context.read();
    if (uniLinksBloc.state is UniLinksUnhandledEventState) {
      _urlController.text =
          (uniLinksBloc.state as UniLinksUnhandledEventState).file.toString();
      uniLinksBloc.add(HandleLastEvent());
      Future.delayed(const Duration(microseconds: 500))
          .then((value) => showDownloadMenu(currentServiceType));
    }

    searchFilesController.addListener(
      () => setState(() {}),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    searchFilesController.removeListener(() {});
    searchFilesController.dispose();
    super.dispose();
  }

  void _downloadFile() async {
    final downloadedFilesCubit = context.read<DownloadedFilesCubit>();

    final fileUrl = _urlController.text.endsWith('/')
        ? _urlController.text
        : '${_urlController.text}/';

    final fileExists = downloadedFilesCubit.state.fileExists(url: fileUrl);

    if (fileExists) {
      final dialogResult = await showDialog(
          context: context, builder: (context) => getAcceptOverrideWidget());

      if (dialogResult == null || dialogResult == false) return;
    }

    final result = await downloadedFilesCubit.addDownloadFile(
        serviceType: currentServiceType,
        url: fileUrl,
        session: currentServiceAuthSession);

    if (!result) return;

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();

    // TODO remove
    // _urlController.text = initialLink;
  }

  Widget getListViewElement(DownloadedFile downloadedFile) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 14.0),
        child: DownloadedFileItem(
          downloadedFile: downloadedFile,
          menuIconPath: 'assets/icons/cloud_upload.svg',
          allowToDelete: true,
          onDeleteButtonTap: () async {
            final dialogResult = await showDialog<bool>(
                context: context,
                builder: (context) => getAcceptDeleteWidget());

            if (dialogResult != true) return;

            // ignore: use_build_context_synchronously
            context
                .read<DownloadedFilesCubit>()
                .deleteFile(downloadedFile: downloadedFile);
          },
          onTap: () {
            OpenFilex.open(downloadedFile.localPath);
          },
          onMenuTap: () async {
            if (BlocProvider.of<UploadBloc>(context).state.uploadStatus ==
                UploadStatus.loading) {
              FToast().showToast(
                  gravity: ToastGravity.TOP,
                  toastDuration: const Duration(seconds: 3),
                  child: PopUpItem(
                    text:
                        'You have an active upload, wait for the upload to finish and try again.',
                    onTap: () {
                      FToast().removeQueuedCustomToasts();
                    },
                  ));
              return;
            }
            final changeServiceResult =
                await ServiceChooserBottomSheet.changeService(context,
                    title: 'Choose Cloud Server');

            if (!changeServiceResult) return;

            // ignore: use_build_context_synchronously
            BlocProvider.of<UploadBloc>(context).add(UploadServer(
                session: currentServiceAuthSession,
                serviceType: currentServiceType,
                files: [downloadedFile.localPlatformFile]));
            // ignore: use_build_context_synchronously
            context.read<MainScreenPageIndexCubit>().setPageIndex(pageIndex: 1);
          },
        ),
      );

  Widget getDownloadedFilesListView() =>
      BlocBuilder<DownloadedFilesCubit, DownloadedFilesCubitState>(
        builder: (context, state) => state
                .downloadedFileListSearchFiles(
                    fileName: searchFilesController.text)
                .isEmpty
            ? Container()
            : ListView.builder(
                key: const PageStorageKey<String>('DownloadedFilesListView'),
                physics: const BouncingScrollPhysics(),
                itemCount: state
                        .downloadedFileListSearchFiles(
                            fileName: searchFilesController.text)
                        .length +
                    1,
                itemBuilder: (context, index) {
                  if (index ==
                      state
                          .downloadedFileListSearchFiles(
                              fileName: searchFilesController.text)
                          .length) {
                    return const SizedBox(height: 30);
                  }
                  return getListViewElement(state.downloadedFileListSearchFiles(
                      fileName: searchFilesController.text)[index]);
                },
              ),
      );

  Widget getAddDownloadButton(ServiceType currentServiceType) => Align(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: () {
              // TODO restore
              _urlController.text = '';
              // TODO remove
              // _urlController.text = initialLink;
              showDownloadMenu(currentServiceType);
            },
            child: SvgPicture.asset(
              'assets/icons/upload_btn.svg',
              width: 44,
              height: 44,
            ),
          ),
        ),
      );

  Widget getAcceptOverrideWidget() => SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
                color: extractorColor,
                borderRadius: BorderRadius.all(Radius.circular(24))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 64,
                    margin: const EdgeInsets.only(top: 44, bottom: 15),
                    child: const Text(
                      'File already exists. Would you like to replace it?',
                      style: h2RWhiteStyle,
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 30),
                  color: accentColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      // width: MediaQuery.of(context).size.width / 2 - 22,
                      child: ButtonApp(
                        text: 'No',
                        onTap: () => Navigator.of(context).pop(false),
                        color: mainBackColor,
                        borderColor: accentColor,
                        textStyle: h2SbWhiteStyle,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Flexible(
                      child: ButtonApp(
                        text: 'Yes',
                        onTap: () => Navigator.of(context).pop(true),
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 35)),
              ],
            ),
          ),
        ),
      );

  Widget getAcceptDeleteWidget() => SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
                color: extractorColor,
                borderRadius: BorderRadius.all(Radius.circular(24))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 64,
                    margin: const EdgeInsets.only(top: 44, bottom: 15),
                    child: const Text(
                      'File will be deleted. Are you sure?',
                      style: h2RWhiteStyle,
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 30),
                  color: accentColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      // width: MediaQuery.of(context).size.width / 2 - 22,
                      child: ButtonApp(
                        text: 'No',
                        onTap: () => Navigator.of(context).pop(false),
                        color: mainBackColor,
                        borderColor: accentColor,
                        textStyle: h2SbWhiteStyle,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Flexible(
                      child: ButtonApp(
                        text: 'Yes',
                        onTap: () => Navigator.of(context).pop(true),
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 35)),
              ],
            ),
          ),
        ),
      );

  Widget getNewDownloadWidget(
          BuildContext context, ServiceType currentServiceType) =>
      SafeArea(
        child: Container(
          padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: const BoxDecoration(
              color: extractorColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 64,
                margin: const EdgeInsets.only(top: 44, bottom: 15),
                child: Text(
                  'Download file from ${currentServiceType.nameRepresent}',
                  style: h2RWhiteStyle,
                ),
              ),
              Container(
                height: 1,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 30),
                color: accentColor,
              ),
              TextFieldApp(
                label: 'Paste File URL',
                hint: 'https://',
                controller: _urlController,
                maxLines: null,
              ),
              const Padding(padding: EdgeInsets.only(top: 32)),
              SizedBox(
                width: MediaQuery.of(context).size.width - 32,
                child: ButtonApp(
                  text: 'Download',
                  disabled: false,
                  onTap: () async {
                    _downloadFile();
                  },
                  color: accentColor,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 35)),
            ],
          ),
        ),
      );

  void showDownloadMenu(ServiceType currentServiceType) async {
    final link = _urlController.text;

    if (link.isNotEmpty &&
        link.contains(ServiceType.novafile.domain) &&
        currentServiceType != ServiceType.novafile &&
        Uri.tryParse(_urlController.text) != null) {
      final result = await ServiceChooserBottomSheet.switchService(context,
          serviceType: ServiceType.novafile);

      if (!result) return;
    }

    if (link.isNotEmpty &&
        link.contains(ServiceType.filejoker.domain) &&
        currentServiceType != ServiceType.filejoker &&
        Uri.tryParse(_urlController.text) != null) {
      // ignore: use_build_context_synchronously
      final result = await ServiceChooserBottomSheet.switchService(context,
          serviceType: ServiceType.filejoker);

      if (!result) return;
    }

    // ignore: use_build_context_synchronously
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => getNewDownloadWidget(context, currentServiceType),
    );
  }

  Widget downloadInProgressWidget(BuildContext context) => BlocBuilder<
          DownloadedFilesCubit, DownloadedFilesCubitState>(
      builder: (context, downloadedFilesCubitState) => downloadedFilesCubitState
                  .currentDownloadingFile ==
              null
          ? Container()
          : Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                    color: extractorColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Downloading',
                          style: h1Style,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          decoration: const BoxDecoration(
                              color: extractorColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(children: [
                            Container(
                                margin: const EdgeInsets.only(right: 12),
                                child: FileIndicator(
                                    progressPercent: downloadedFilesCubitState
                                        .currentDownloadingFile!
                                        .progressPercent,
                                    onTap: () => context
                                        .read<DownloadedFilesCubit>()
                                        .cancelDownload())),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    downloadedFilesCubitState
                                        .currentDownloadingFile!
                                        .currentDownloadedFile
                                        .fileName,
                                    style: h3RStyle,
                                    maxLines: 2,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    downloadedFilesCubitState
                                        .currentDownloadingFile!.progress
                                        .fileSizeOfTotalRepresentInMb(
                                            downloadedFilesCubitState
                                                .currentDownloadingFile!
                                                .currentDownloadedFile
                                                .size),
                                    style: h4MenuStyle,
                                  ),
                                  Text(
                                    'Loaded ${downloadedFilesCubitState.currentDownloadingFile!.progress.fileSizeOfTotalRepresentInPercent(downloadedFilesCubitState.currentDownloadingFile!.currentDownloadedFile.size)}',
                                    style: h4AccentStyle,
                                  )
                                ],
                              ),
                            ),
                          ]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (MediaQuery.of(context).size.width -
                                      16 * 2 -
                                      12 * 2 -
                                      6) /
                                  2,
                              child: ButtonApp(
                                text: 'Cancel',
                                color: optionalColor,
                                disabled: downloadedFilesCubitState
                                        .currentDownloadingStatus !=
                                    DownloadingStatus.donwloading,
                                textStyle: h2SbWhiteStyle,
                                borderColor: azureColor,
                                onTap: () => context
                                    .read<DownloadedFilesCubit>()
                                    .cancelDownload(),
                              ),
                            ),
                            SizedBox(
                              width: (MediaQuery.of(context).size.width -
                                      16 * 2 -
                                      12 * 2 -
                                      6) /
                                  2,
                              child: ButtonApp(
                                text: 'Ok',
                                color: accentColor,
                                onTap: () => Navigator.of(context).pop(),
                                disabled: downloadedFilesCubitState
                                        .currentDownloadingStatus ==
                                    DownloadingStatus.donwloading,
                              ),
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
            ));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentServiceCubit, ServiceType>(
        builder: (context, currentServiceType) =>
            BlocBuilder<DownloadedFilesCubit, DownloadedFilesCubitState>(
              buildWhen: (previous, current) =>
                  previous.currentDownloadingStatus !=
                  current.currentDownloadingStatus,
              builder: (context, downloadedFilesCubitState) => GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: BlocListener<UniLinksBloc, UniLinksState>(
                  listenWhen: (previous, current) =>
                      current is UniLinksUnhandledEventState,
                  listener: (context, state) {
                    if (state is UniLinksUnhandledEventState) {
                      _urlController.text = state.file.toString();

                      showDownloadMenu(currentServiceType);

                      final UniLinksBloc uniLinksBloc = context.read();
                      uniLinksBloc.add(HandleLastEvent());
                    }
                  },
                  child: SafeArea(
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            HeaderApp(
                              title: 'Download file',
                              leftIcon: SvgPicture.asset(
                                'assets/icons/check_service_icon.svg',
                                width: 24,
                                height: 24,
                              ),
                              leftTap: () =>
                                  ServiceChooserBottomSheet.changeService(
                                      context,
                                      title: 'Choose Cloud Server'),
                              rightTap: () => Navigator.of(context).push(
                                  LogoutScreen.materialPageRoute(
                                      serviceType: currentServiceType)),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
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
                            BlocBuilder<NetworkStatusCubit, NetworkStatus>(
                              builder: (context, state) =>
                                  state == NetworkStatus.loading
                                      ? const CircularProgressIndicator()
                                      : Container(),
                            ),
                            Expanded(
                              child: getDownloadedFilesListView(),
                            ),
                            downloadedFilesCubitState
                                        .currentDownloadingStatus ==
                                    DownloadingStatus.donwloading
                                ? downloadInProgressWidget(context)
                                : Container(),
                          ],
                        ),
                        downloadedFilesCubitState.currentDownloadingStatus !=
                                DownloadingStatus.donwloading
                            ? getAddDownloadButton(currentServiceType)
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
