import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart/managers/blocked_users_manager.dart';

part 'blocked_users_state.dart';

class BlockedUsersCubit extends Cubit<BlockedUsersState> {
  final BlockedUsersManager blockedUsersManager;

  BlockedUsersCubit({required this.blockedUsersManager})
      : super(BlockedUsersInitial());

  void blockUser(String userId) async {
    emit(BlockedUsersUpdatingState());
    try {
      await blockedUsersManager.block(userId);
      emit(BlockedUsersUpdatedState());
    } catch (e) {
      emit(BlockedUsersFailState());
    }
  }

  void unblockUser(String userId) async {
    emit(BlockedUsersUpdatingState());
    try {
      await blockedUsersManager.unblock(userId);
      emit(BlockedUsersUpdatedState());
    } catch (e) {
      emit(BlockedUsersFailState());
    }
  }
}
