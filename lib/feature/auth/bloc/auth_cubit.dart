import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/utils/functions.dart';

import '../../../enum/enum.dart';
import '../data/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthRepository authRepository;
  String _phone = '';
  String _nameForRegistration = '';
  String _passwordForRegistration = '';

  AuthCubit({required this.authRepository}) : super(AuthInitial()) {
    authRepository.authState.stream.listen((event) {
      if (event == EntranceStateEnum.success) emit(AuthSuccessState());
      if (event == EntranceStateEnum.loading) emit(AuthLoadingState());
      if (event == EntranceStateEnum.fail) emit(AuthFailState());
      if (event == EntranceStateEnum.alreadyExist) emit(AlreadyExistState());
    });
  }

  setPhoneForLogin(String newPhone) => _phone = newPhone;

  registerWithPhone(
      {required String phone, required String name, required String password}) {
    _nameForRegistration = name;
    _passwordForRegistration = password;
    _phone = phone;
    _sendSms();
  }

  loginWithPhone({required String password}) {
    final email = convertPhoneToVerifiedEmail(_phone);
    authRepository.login(email, password);
  }

  void _sendSms() async {
    if (_phone.isEmpty) throw Exception('phone must not be empty');
    await authRepository.createAccountAndSendSms(_phone);
  }

  void confirmCode(String code) async {
    await authRepository.confirmCode(
      code,
      password: _passwordForRegistration,
      name: _nameForRegistration,
    );
  }

  Future<void> logout() => authRepository.logout();
}
