import 'package:bloc/bloc.dart';

class MainScreenPageIndexCubit extends Cubit<int> {
  MainScreenPageIndexCubit() : super(0);

  void setPageIndex({required int pageIndex}) => emit(pageIndex);
}
