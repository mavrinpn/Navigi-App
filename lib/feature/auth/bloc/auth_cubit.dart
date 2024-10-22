import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../data/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthRepository authRepository;
  String _phone = '';
  String _email = '';
  String _name = '';
  String _password = '';

  AuthCubit({required this.authRepository}) : super(AuthInitial());

  setPhoneForLogin(String newPhone) => _phone = newPhone;
  setEmailForLogin(String newEMail) => _email = newEMail;
  String getEmailForLogin() => _email;

  registerWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _name = name;
    _password = password;
    _email = email;
    _phone = phone;
    emit(UserCreatingState());
    final result = await authRepository.createEmailAccount(
      email: _email,
      password: _password,
      name: _name,
      phone: _phone,
    );
    if (result == null) {
      await authRepository.sendEmailCode(
        email: _email,
        password: _password,
      );
      emit(UserSuccessCreatedState());
    } else {
      emit(UserAlreadyExistState());
    }
  }

  registerWithApple() async {
    emit(UserCreatingState());
    final result = await authRepository.signInWithApple();
    if (result == null) {
      emit(UserSuccessCreatedState());
    } else {
      emit(UserAlreadyExistState());
    }
  }

  registerWithGoogle() async {
    emit(UserCreatingState());
    final result = await authRepository.signInWithGoogle();
    if (result == null) {
      emit(UserSuccessCreatedState());
    } else {
      emit(UserAlreadyExistState());
    }
  }

  void restorePasswordWithEmail({
    required String email,
    required String password,
  }) async {
    emit(UserCreatingState());
    _password = password;
    _email = email;
    await authRepository.sendEmailCode(
      email: _email,
      password: _password,
    );
    emit(UserSuccessCreatedState());
  }

  loginWithEmail({required String password}) async {
    final email = _email;
    emit(AuthLoadingState());
    final result = await authRepository.login(email, password);
    if (result == null) {
      emit(AuthSuccessState());
    } else if (result == 'user-not-verificated') {
      await authRepository.sendEmailCode(
        email: _email,
        password: _password,
      );
      emit(AuthUserNotVerificated());
    } else {
      emit(AuthFailState());
    }
  }

  Future<void> confirmEmailCode({
    required String code,
  }) async {
    emit(AuthLoadingState());

    final result = await authRepository.confirmEmailCode(
      code,
      password: _password,
      name: _name,
      phone: _phone,
      email: _email,
    );

    if (result == null) {
      emit(AuthSuccessState());
    } else if (result == 'error_invalid_code') {
      emit(AuthErrorInvalidCode());
    } else {
      emit(AuthFailState());
    }
  }

  Future<void> updateEmailPassword({
    required String code,
  }) async {
    emit(AuthLoadingState());

    final result = await authRepository.updateEmailCode(
      code,
      password: _password,
      email: _email,
    );

    if (result == null) {
      emit(AuthPasswordUpdateSuccessState());
    } else if (result == 'error_invalid_code') {
      emit(AuthErrorInvalidCode());
    } else if (result == 'error_abuse_24hour') {
      emit(AuthFailState());
    } else {
      emit(AuthFailState());
    }
  }

  Future<void> logout() => authRepository.logout();

  Future<void> deleteIdentity() => authRepository.deleteIdentity();

  Future<void> setUserData({
    required String name,
    required String phone,
  }) async {
    authRepository.setUserData(
      name: name,
      phone: phone,
    );
  }
}
