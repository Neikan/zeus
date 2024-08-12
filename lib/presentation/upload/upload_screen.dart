// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/statuses_cubit/current_service_cubit.dart';
import 'package:zeusfile/presentation/account/logout_screen.dart';
import 'package:zeusfile/presentation/authorization/bloc/auth_bloc.dart';
import 'package:zeusfile/presentation/files/bloc/files_bloc.dart';
import 'package:zeusfile/presentation/upload/bloc/upload_bloc.dart';
import 'package:zeusfile/presentation/widgets/file_indicator.dart';
import 'package:zeusfile/presentation/widgets/modal_menu.dart';
import 'package:zeusfile/presentation/widgets/button_app.dart';
import 'package:zeusfile/presentation/widgets/header_app.dart';
import 'package:zeusfile/presentation/widgets/service_chooser_bottom_sheet.dart';
import 'package:zeusfile/utils/enums.dart';
import 'package:zeusfile/utils/represent_utils.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final cancelToken = CancelToken();

  bool filesChoosing = false;

  ServiceAuth get currentServiceAuth =>
      (context.read<AuthBloc>().state is CheckedAuthState)
          ? (context.read<AuthBloc>().state as CheckedAuthState).getServiceAuth(
              serviceType: context.read<CurrentServiceCubit>().state)
          : context.read<AuthBloc>().state.filejokerServiceAuth;

  String get currentServiceAuthSession => currentServiceAuth.session ?? '';

  void cancelUpload(
          BuildContext context, void Function([dynamic])? cancelUpload) =>
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return ModalMenu(
              title: 'Are you sure?',
              items: [
                ModalMenuItem(
                  title: 'Yes, cancel uploading',
                  icon: SvgPicture.asset(
                    'assets/icons/close.svg',
                    width: 24,
                    height: 24,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    cancelUpload != null ? cancelUpload() : null;
                  },
                ),
                ModalMenuItem(
                  title: 'No, continue uploading',
                  icon: SvgPicture.asset(
                    'assets/icons/upload_done.svg',
                    width: 24,
                    height: 24,
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            );
          });

  Widget uploadInProgressWidget(BuildContext context, UploadState state) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: const Text(
            'Files Upload',
            style: h1Style,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 24, bottom: 24),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: const BoxDecoration(
              color: extractorColor,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(children: [
            Container(
                margin: const EdgeInsets.only(right: 12),
                child: FileIndicator(
                    progressPercent: state.progress,
                    onTap: () =>
                        cancelUpload(context, state.cancelToken?.cancel))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 110,
                  child: Text(
                    state.files.length == 1
                        ? state.files[0].name
                        : '${state.files.length} files',
                    style: h3RStyle,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  state.countBytes
                      .fileSizeOfTotalRepresentInMb(state.totalBytes),
                  style: h4MenuStyle,
                ),
                Text(
                  'Loaded ${state.countBytes.fileSizeOfTotalRepresentInPercent(state.totalBytes)}',
                  style: h4AccentStyle,
                )
              ],
            ),
          ]),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: ButtonApp(
                text: 'Cancel',
                color: optionalColor,
                disabled: false,
                textStyle: h2SbWhiteStyle,
                borderColor: azureColor,
                onTap: () => cancelUpload(context, state.cancelToken?.cancel),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            const Flexible(
              child: ButtonApp(
                text: 'Done',
                color: accentColor,
                disabled: true,
              ),
            ),
          ],
        ),
      ]);

  void onDone(BuildContext context, ServiceType currentServiceType) {
    BlocProvider.of<UploadBloc>(context).add(const UploadInit());
    BlocProvider.of<UploadBloc>(context).add(UploadProgress(
        countBytes: 0,
        progress: 0,
        totalBytes: 0,
        serviceType: currentServiceType));
    context.read<FilesBloc>().add(GetFiles(
        session: currentServiceAuthSession, serviceType: currentServiceType));
  }

  Widget uploadSuccessWidget(BuildContext context, UploadState state,
          ServiceType currentServiceType) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: const Text(
            'Files Upload',
            style: h1Style,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 24, bottom: 24),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: const BoxDecoration(
              color: extractorColor,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(children: [
            Container(
                margin: const EdgeInsets.only(right: 12),
                child: FileIndicator(
                    progressPercent: state.progress,
                    color: confirmationColor,
                    iconAsset: 'assets/icons/upload_done.svg',
                    onTap: ([dynamic temp]) =>
                        onDone(context, currentServiceType))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 110,
                  child: Text(
                    state.files.length == 1
                        ? state.files[0].name
                        : '${state.files.length} files',
                    style: h3RStyle,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  state.countBytes
                      .fileSizeOfTotalRepresentInMb(state.totalBytes),
                  style: h4MenuStyle,
                ),
                Text(
                  'Loaded ${state.countBytes.fileSizeOfTotalRepresentInPercent(state.totalBytes)}',
                  style: h4AccentStyle,
                )
              ],
            ),
          ]),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Flexible(
              child: ButtonApp(
                text: 'Cancel',
                color: optionalColor,
                disabled: true,
                disabledTextStyle: h2SbAzureStyle,
                disabledBorderColor: azureColor,
                borderColor: azureColor,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Flexible(
              child: ButtonApp(
                text: 'Done',
                color: accentColor,
                disabled: false,
                onTap: () => onDone(context, currentServiceType),
              ),
            ),
          ],
        ),
      ]);

  Widget readyToUploadWidget(BuildContext context, UploadState state,
          ServiceType currentServiceType) =>
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                'Select Files to Upload to ${currentServiceType.nameRepresent}',
                style: h1Style,
              ),
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return ModalMenu(
                        title: 'Choose download location',
                        items: [
                          ModalMenuItem(
                              title: 'Media library',
                              icon: SvgPicture.asset(
                                'assets/icons/media.svg',
                                width: 24,
                                height: 24,
                              ),
                              onTap: () async {
                                setState(() => filesChoosing = true);

                                try {
                                  final result = await FilePicker.platform
                                      .pickFiles(
                                          allowMultiple: true, withData: false);

                                  Navigator.of(context).pop();

                                  if (result != null) {
                                    BlocProvider.of<UploadBloc>(context).add(
                                        UploadServer(
                                            session: currentServiceAuthSession,
                                            serviceType: currentServiceType,
                                            files: result.files));
                                  }
                                } finally {
                                  setState(() => filesChoosing = false);
                                }
                              }),
                          ModalMenuItem(
                            title: 'Use camera',
                            icon: SvgPicture.asset(
                              'assets/icons/camera.svg',
                              width: 24,
                              height: 24,
                            ),
                            onTap: () async {
                              setState(() => filesChoosing = true);
                              try {
                                final picker = ImagePicker();
                                final photo = await picker.pickImage(
                                    source: ImageSource.camera);

                                if (photo != null) {
                                  BlocProvider.of<UploadBloc>(context).add(
                                      UploadServer(
                                          session: currentServiceAuthSession,
                                          serviceType: currentServiceType,
                                          files: [
                                        PlatformFile(
                                            path: photo.path,
                                            name: photo.name,
                                            size: await photo.length())
                                      ]));
                                  Navigator.of(context).pop();
                                }
                              } finally {
                                setState(() => filesChoosing = false);
                              }
                            },
                          ),
                        ],
                      );
                    });
              },
              child: SvgPicture.asset(
                'assets/icons/upload_btn.svg',
                width: 44,
                height: 44,
              ),
            )
          ]);

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<CurrentServiceCubit, ServiceType>(
          builder: (context, currentServiceType) => Container(
                height: MediaQuery.of(context).size.height,
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HeaderApp(
                        title: 'Upload Files',
                        rightTap: () => Navigator.of(context).push(
                            LogoutScreen.materialPageRoute(
                                serviceType: currentServiceType)),
                        leftIcon: SvgPicture.asset(
                          'assets/icons/check_service_icon.svg',
                          width: 24,
                          height: 24,
                        ),
                        leftTap: () => ServiceChooserBottomSheet.changeService(
                            context,
                            title: 'Choose Cloud Server'),
                      ),
                      Flexible(
                          child: SingleChildScrollView(
                        child: Column(children: [
                          Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/icons/upload_back.png',
                                  width: MediaQuery.of(context).size.width - 70,
                                  height:
                                      MediaQuery.of(context).size.width - 70,
                                ),
                              ),
                              filesChoosing
                                  ? const Align(
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(),
                                    )
                                  : Container()
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 16),
                            padding: const EdgeInsets.only(bottom: 32, top: 48),
                            decoration: const BoxDecoration(
                                border: Border.symmetric(
                                    horizontal: BorderSide(
                                        color: accentColor, width: 1))),
                            child: BlocBuilder<UploadBloc, UploadState>(
                                builder: (context, state) {
                              if (state.status == NetworkStatus.loading &&
                                  state.uploadStatus == UploadStatus.initial) {
                                return readyToUploadWidget(
                                  context,
                                  state,
                                  currentServiceType,
                                );
                              }

                              if (state.status == NetworkStatus.loading &&
                                  state.uploadStatus == UploadStatus.loading) {
                                return uploadInProgressWidget(context, state);
                              }

                              if (state.status == NetworkStatus.success &&
                                  state.uploadStatus == UploadStatus.uploaded) {
                                return uploadSuccessWidget(
                                    context, state, currentServiceType);
                              }

                              return readyToUploadWidget(
                                  context, state, currentServiceType);
                            }),
                          ),
                        ]),
                      ))
                    ]),
              ));
}
