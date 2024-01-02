import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../enum/enum.dart';
import '../data/auth_repository.dart';


part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthRepository authRepository;
  String _phone = '';

  AuthCubit({required this.authRepository}) : super(AuthInitial()) {
    authRepository.authState.stream.listen((event) {
      if (event == EntranceStateEnum.success) emit(AuthSuccessState());
      if (event == EntranceStateEnum.loading) emit(AuthLoadingState());
      if (event == EntranceStateEnum.fail) emit(AuthFailState());
      if (event == EntranceStateEnum.alreadyExist) emit(AlreadyExistState());
    });
  }

  setPhone(String newPhone) => _phone = newPhone;

  String getPhone() => _phone;


  //TODO удалить в будущем
  registerWithEmail(
          {required String email,
          required String name,
          required String password}) {
    // authRepository.registerWithEmail(
    //     email: email, password: password);
  }

  //TODO удалить в будущем
  loginWithEmail({required String email, required String password}) {
    // authRepository.loginWithEmail(email: email, password: password);
  }


  void sendSms() async {
    if (_phone.isEmpty) throw Exception('phone must not be empty');
    await authRepository.createAccountAndSendSms(_phone);
  }

  void confirmCode(String code) async {
    await authRepository.confirmCode(code);
  }

  logout() => authRepository.logout();
}
