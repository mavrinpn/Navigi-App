import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/utils/functions.dart';

import '../../../enum/enum.dart';
import '../data/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthRepository authRepository;
  String _phone = '';
  String _email = '';
  String _nameForRegistration = '';
  String _passwordForRegistration = '';

  AuthCubit({required this.authRepository}) : super(AuthInitial()) {
    authRepository.authState.stream.listen((event) {
      if (event == EntranceStateEnum.success) emit(AuthSuccessState());
      if (event == EntranceStateEnum.loading) emit(AuthLoadingState());
      if (event == EntranceStateEnum.fail) emit(AuthFailState());
      if (event == EntranceStateEnum.alreadyExist) emit(AlreadyExistState());
      if (event == EntranceStateEnum.userNotFound) emit(NotFoundState());
    });
  }

  setPhoneForLogin(String newPhone) => _phone = newPhone;
  setEmailForLogin(String newEMail) => _email = newEMail;

  registerWithPhone({
    required String phone,
    required String name,
    required String password,
  }) {
    _nameForRegistration = name;
    _passwordForRegistration = password;
    _phone = phone;
    _sendSms(isPasswordRestore: false);
  }

  registerWithEmail({
    required String email,
    required String name,
    required String password,
  }) {
    _nameForRegistration = name;
    _passwordForRegistration = password;
    _email = email;
    _sendEmailCode(isPasswordRestore: false);
  }

  restorePassword({
    required String phone,
    required String password,
  }) {
    _passwordForRegistration = password;
    _phone = phone;
    _sendSms(isPasswordRestore: true);
  }

  restorePasswordWithEmail({
    required String email,
    required String password,
  }) {
    _passwordForRegistration = password;
    _email = email;
    _sendEmailCode(isPasswordRestore: true);
  }

  loginWithPhone({required String password}) {
    final email = convertPhoneToVerifiedEmail(_phone);
    authRepository.login(email, password);
  }

  loginWithEmail({required String password}) {
    final email = _email;
    authRepository.login(email, password);
  }

  void _sendSms({required bool isPasswordRestore}) async {
    if (_phone.isEmpty) throw Exception('phone must not be empty');
    await authRepository.createAccountAndSendSms(
      phone: _phone,
      isPasswordRestore: isPasswordRestore,
    );
  }

  void _sendEmailCode({required bool isPasswordRestore}) async {
    if (_email.isEmpty) throw Exception('E-mail must not be empty');
    await authRepository.createAccountAndSendEmailCode(
      email: _email,
      isPasswordRestore: isPasswordRestore,
    );
  }

  Future<void> confirmCode({
    required String code,
    required bool isPasswordRestore,
  }) async {
    await authRepository.confirmCode(
      code,
      password: _passwordForRegistration,
      name: _nameForRegistration,
      isPasswordRestore: isPasswordRestore,
    );
  }

  Future<void> logout() => authRepository.logout();
}
