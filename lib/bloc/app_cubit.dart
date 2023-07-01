import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../data/app_repository.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppRepository appRepository;

  AppCubit({required this.appRepository}) : super(AppInitial()) {
    appRepository.appState.stream.listen((event) {
      if (event == AuthStateEnum.auth) emit(AppAuthState());
      if (event == AuthStateEnum.unAuth) emit(AppUnAuthState());
    });
  }
}
