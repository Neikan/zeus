// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zeusfile/constants.dart';
import 'package:zeusfile/data/auth/auth_rest.dart';
import 'package:zeusfile/data/dio.dart';
import 'package:zeusfile/data/download/download_rest.dart';
import 'package:zeusfile/data/downloaded_files_cubit/downloaded_files_cubit.dart';
import 'package:zeusfile/data/files/files_rest.dart';
import 'package:zeusfile/data/hive/hive_repository.dart';
import 'package:zeusfile/data/interceptors/error_interceptor.dart';
import 'package:zeusfile/data/statuses_cubit/current_service_cubit.dart';
import 'package:zeusfile/data/statuses_cubit/network_status_cubit.dart';
import 'package:zeusfile/data/statuses_cubit/upload_status_cubit.dart';
import 'package:zeusfile/data/uni_links/uni_links_bloc.dart';
import 'package:zeusfile/data/upload/upload_rest.dart';
import 'package:zeusfile/presentation/authorization/bloc/auth_bloc.dart';
import 'package:zeusfile/presentation/download/bloc/download_bloc.dart';
import 'package:zeusfile/presentation/files/bloc/files_bloc.dart';
import 'package:zeusfile/presentation/main/main_screen.dart';
import 'package:zeusfile/presentation/preloader/preloader_screen.dart';
import 'package:zeusfile/presentation/service/services_screen.dart';
import 'package:zeusfile/presentation/upload/bloc/upload_bloc.dart';
import 'package:zeusfile/purchase/cubit/purchase_cubit.dart';
import 'package:zeusfile/purchase/purchase_service.dart';
import 'package:zeusfile/repository/auth_repository.dart';
import 'package:zeusfile/repository/download_repository.dart';
import 'package:zeusfile/repository/files_repository.dart';
import 'package:zeusfile/repository/upload_repository.dart';
import 'package:zeusfile/routes.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'presentation/main/cubit/main_screen_page_index_cubit.dart';

late HiveRepository hiveRepository;

void main() async {
  await HiveRepository.hiveInit();
  hiveRepository = HiveRepository.repository();

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ExtendedAuthRest>.value(
            value: ExtendedAuthRest.baseUrls(dioInstance())),
        RepositoryProvider<ExtendedUploadRest>.value(
            value: ExtendedUploadRest.baseUrls(dioInstance())),
        RepositoryProvider<ExtendedFilesRest>.value(
            value: ExtendedFilesRest.baseUrls(dioInstance())),
        RepositoryProvider<ExtendedDownloadRest>.value(
            value: ExtendedDownloadRest.baseUrls(dioInstance())),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthRepository>(
            create: (context) =>
                AuthRepository(extendedAuthRest: context.read()),
          ),
          RepositoryProvider<UploadRepository>(
            create: (context) =>
                UploadRepository(extendedUploadRest: context.read()),
          ),
          RepositoryProvider<FilesRepository>(
            create: (context) => FilesRepository(filesRest: context.read()),
          ),
          RepositoryProvider<DownloadRepository>(
            create: (context) =>
                DownloadRepository(downloadRest: context.read()),
          ),
          RepositoryProvider<HiveRepository>.value(value: hiveRepository),
          RepositoryProvider<PurchaseService>.value(value: PurchaseService()),
        ],
        child: MultiBlocProvider(providers: [
          BlocProvider<NetworkStatusCubit>(
              create: (context) => NetworkStatusCubit()),
          BlocProvider<UploadStatusCubit>(
              create: (context) => UploadStatusCubit()),
          BlocProvider<CurrentServiceCubit>(
              create: (context) => CurrentServiceCubit()),
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
                authRepository: context.read(),
                networkStatusCubit: context.read()),
          ),
          BlocProvider<UploadBloc>(
            create: (context) => UploadBloc(uploadRepository: context.read()),
          ),
          BlocProvider<FilesBloc>(
            create: (context) => FilesBloc(
                filesRepository: context.read(),
                networkStatusCubit: context.read()),
          ),
          BlocProvider<DownloadBloc>(
            create: (context) =>
                DownloadBloc(downloadRepository: context.read()),
          ),
          BlocProvider<UniLinksBloc>(
            create: (context) => UniLinksBloc(),
          ),
          BlocProvider<DownloadedFilesCubit>(
            create: (context) => DownloadedFilesCubit(
                hiveRepository: context.read(),
                downloadRest: context.read(),
                networkStatusCubit: context.read()),
          ),
          BlocProvider<MainScreenPageIndexCubit>(
            create: (context) => MainScreenPageIndexCubit(),
          ),
          BlocProvider<PurchaseCubit>(
            create: (context) => PurchaseCubit(
                purchaseService: context.read(),
                authRepository: context.read()),
          ),
        ], child: const MyApp()),
      ),
    ),
  );
}

bool toastIsInit = false;

final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zeus File Manager',
      navigatorKey: _navigator,
      debugShowCheckedModeBanner: false,
      builder: ((context, child) {
        return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) {
                if (!toastIsInit) {
                  FToast().init(context);
                  initializeDateFormatting('en');
                  dioErrorInterceptor.globalContext = context;
                  dioErrorInterceptor.navigatorKey = _navigator;
                  toastIsInit = true;
                }
                return BlocListener<UniLinksBloc, UniLinksState>(
                    listener: (context, state) {
                      // Listener is needed to init unilinks bloc before main screen appears
                    },
                    child: BlocListener<AuthBloc, AuthState>(
                      listener: (context, authBlocState) {
                        final CurrentServiceCubit currentServiceCubit =
                            context.read();

                        if (authBlocState.authorizedCount > 0 &&
                            !authBlocState
                                .getServiceAuth(
                                    serviceType: currentServiceCubit.state)
                                .authorized) {
                          currentServiceCubit.swipe();
                        }
                      },
                      child: BlocListener<CurrentServiceCubit, ServiceType>(
                        listenWhen: (previous, current) => true,
                        listener: (context, currentServiceType) {
                          ServiceAuth currentServiceAuth = (context
                                  .read<AuthBloc>()
                                  .state is CheckedAuthState)
                              ? (context.read<AuthBloc>().state
                                      as CheckedAuthState)
                                  .getServiceAuth(
                                      serviceType: currentServiceType)
                              : context
                                  .read<AuthBloc>()
                                  .state
                                  .filejokerServiceAuth;

                          if ((currentServiceAuth.session ?? '').isNotEmpty) {
                            final FilesBloc filesBloc = context.read();
                            filesBloc.add(GetFiles(
                                session: currentServiceAuth.session ?? '',
                                folder:
                                    filesBloc.state.selectedFolder.isNotEmpty
                                        ? filesBloc.state.selectedFolder.last
                                        : null,
                                isPaginate: false,
                                serviceType: currentServiceAuth.serviceType));
                          }
                        },
                        child: BlocListener<AuthBloc, AuthState>(
                          listenWhen: (previous, current) =>
                              previous.runtimeType != current.runtimeType ||
                              (current is CheckedAuthState &&
                                  previous is CheckedAuthState &&
                                  current.authorized != previous.authorized),
                          listener: (ctx, state) {
                            if (state is CheckedAuthState && state.authorized) {
                              // TODO init of upload and download blocks
                              // BlocProvider.of<UploadBloc>(context)
                              //     .add(UploadInit());

                              final FilesBloc filesBloc = context.read();
                              if (state.filejokerAuthorized &&
                                  (state.filejokerServiceAuth.session ?? '')
                                      .isNotEmpty) {
                                filesBloc.add(GetFiles(
                                    session:
                                        state.filejokerServiceAuth.session ??
                                            '',
                                    folder: filesBloc
                                            .state.selectedFolder.isNotEmpty
                                        ? filesBloc.state.selectedFolder.last
                                        : null,
                                    isPaginate: false,
                                    serviceType: ServiceType.filejoker));
                              }
                              _navigator.currentState?.pushNamedAndRemoveUntil(
                                  MainScreen.routeName,
                                  (Route<dynamic> route) => false);
                              return;
                            }

                            // print('Status: ${state.status}');
                            // print('AUTH: ${state.isAuth}');
                            // print('Service: ${state.currentService}');
                            // print('SESSION: ${state.session}');

                            if (state is CheckedAuthState &&
                                !state.authorized) {
                              _navigator.currentState?.pushNamedAndRemoveUntil(
                                  ServicesScreen.routeName,
                                  (Route<dynamic> route) => false);
                              return;
                            }

                            // if (state.status == NetworkStatus.success &&
                            //     state.isAuth == false &&
                            //     state.currentService != null) {
                            //   print(ModalRoute.of(_navigator.currentContext!)
                            //       ?.settings
                            //       .name);
                            //   _navigator.currentState
                            //       ?.pushReplacementNamed(AuthScreen.routeName);
                            // }
                          },
                          child: child,
                        ),
                      ),
                    ));
              },
            )
          ],
        );
      }),
      initialRoute: PreloaderScreen.routeName,
      routes: routes,
    );
  }
}
