import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeusfile/constants.dart';

class CurrentServiceCubit extends Cubit<ServiceType> {
  CurrentServiceCubit() : super(ServiceType.filejoker);

  void filejoker() => emit(ServiceType.filejoker);
  void novafile() => emit(ServiceType.novafile);
  void service({required ServiceType serviceType}) => emit(serviceType);
  void swipe() {
    switch (state) {
      case ServiceType.filejoker:
        emit(ServiceType.novafile);
        break;
      case ServiceType.novafile:
        emit(ServiceType.filejoker);
        break;
    }
  }
}
