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

  AuthCubit({required this.authRepository}) : super(AuthInitial()) {
    // authRepository.authState.stream.listen((event) {
    //   if (event == EntranceStateEnum.success) emit(AuthSuccessState());
    //   if (event == EntranceStateEnum.loading) emit(AuthLoadingState());
    //   if (event == EntranceStateEnum.fail) emit(AuthFailState());
    //   if (event == EntranceStateEnum.alreadyExist) emit(UserAlreadyExistState());
    //   if (event == EntranceStateEnum.userNotFound) emit(NotFoundState());
    // });
  }

  setPhoneForLogin(String newPhone) => _phone = newPhone;
  setEmailForLogin(String newEMail) => _email = newEMail;
  String getEmailForLogin() => _email;

  // registerWithPhone({
  //   required String phone,
  //   required String name,
  //   required String password,
  // }) {
  //   _name = name;
  //   _password = password;
  //   _phone = phone;
  //   _sendSms(isPasswordRestore: false);
  // }

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

  // void sendEmailCode() async {
  //   await authRepository.sendEmailCode(
  //     email: _email,
  //     password: _password,
  //   );
  // }

  // restorePassword({
  //   required String phone,
  //   required String password,
  // }) {
  //   _password = password;
  //   _phone = phone;
  //   _sendSms(isPasswordRestore: true);
  // }

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

  // loginWithPhone({required String password}) {
  //   final email = convertPhoneToVerifiedEmail(_phone);
  //   authRepository.login(email, password);
  // }

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

  // void _sendSms({required bool isPasswordRestore}) async {
  //   if (_phone.isEmpty) throw Exception('phone must not be empty');
  //   await authRepository.createAccountAndSendSms(
  //     phone: _phone,
  //     isPasswordRestore: isPasswordRestore,
  //   );
  // }

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
}
