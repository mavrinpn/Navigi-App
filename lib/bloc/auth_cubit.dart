import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../data/app_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AppRepository appRepository;
  String phone = '';

  AuthCubit({required this.appRepository}) : super(AuthInitial()) {
    appRepository.authState.stream.listen((event) {
      if (event == AuthStateEnum.auth) emit(AuthSuccessState());
      if (event == AuthStateEnum.loading) emit(AuthLoadingState());
      if (event == AuthStateEnum.unAuth) emit(AuthFailState());
    });
  }

  setPhone(String newPhone) => phone = newPhone;

  String getPhone() => phone;

  registerWithEmail(
          {required String email,
          required String name,
          required String password}) =>
      appRepository.registerWithEmail(
          email: email, password: password, name: name);

  loginWithEmail({required String email, required String password}) =>
      appRepository.loginWithEmail(email: email, password: password);

  logout() => appRepository.logout();
}
