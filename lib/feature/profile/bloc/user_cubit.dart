import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/auth_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AuthRepository authRepository;

  UserCubit({required this.authRepository}) : super(UserInitial()) {
    authRepository.profileState.stream.listen((event) {
      if (event == LoadingStateEnum.loading) emit(ProfileLoadingState());
      if (event == LoadingStateEnum.success) emit(ProfileSuccessState());
      if (event == LoadingStateEnum.fail) emit(ProfileFailState());
    });
  }

  void editProfile({String? name, String? phone, Uint8List? bytes}) =>
      authRepository.editProfile(name: name, phone: phone, bytes: bytes);
}
