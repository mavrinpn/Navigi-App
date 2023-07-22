import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../data/auth_repository.dart';


part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthRepository appRepository;
  String phone = '';

  AuthCubit({required this.appRepository}) : super(AuthInitial()) {
    appRepository.authState.stream.listen((event) {
      if (event == EntranceStateEnum.success) emit(AuthSuccessState());
      if (event == EntranceStateEnum.loading) emit(AuthLoadingState());
      if (event == EntranceStateEnum.fail) emit(AuthFailState());
      if (event == EntranceStateEnum.alreadyExist) emit(AlreadyExistState());
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
