import 'package:bloc/bloc.dart';

part 'scroll_state.dart';

class ScrollCubit extends Cubit<ScrollState> {
  ScrollCubit() : super(ScrollInitial());

  void scrollToTop() {
    emit(ScrollToTop());
    emit(ScrollInitial());
  }
}
