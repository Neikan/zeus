import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeusfile/utils/enums.dart';

class NetworkStatusCubit extends Cubit<NetworkStatus> {
  NetworkStatusCubit() : super(NetworkStatus.initial);

  void loading() => emit(NetworkStatus.loading);
  void success() => emit(NetworkStatus.success);
  void error() => emit(NetworkStatus.error);
}
