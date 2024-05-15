import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:smart/feature/messenger/data/messenger_repository.dart';

import '../../enum/enum.dart';
import '../../feature/auth/data/auth_repository.dart';
import '../../managers/announcement_manager.dart';
import '../../managers/favourites_manager.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AuthRepository appRepository;
  AnnouncementManager announcementManager;
  FavouritesManager favouritesManager;
  MessengerRepository messengerRepository;

  AppCubit({
    required this.appRepository,
    required this.announcementManager,
    required this.messengerRepository,
    required this.favouritesManager,
  }) : super(AppInitial()) {
    appRepository.appState.stream.listen((event) {
      if (event == AuthStateEnum.auth) {
        announcementManager.addLimitAnnouncements(true);
        favouritesManager.userId = appRepository.userId;
        favouritesManager.getFavourites();
        messengerRepository.userId = appRepository.userId;

        //* preloadChats
        messengerRepository.preloadChats();
        messengerRepository.refreshSubscription();

        emit(AppAuthState());
      }
      if (event == AuthStateEnum.unAuth) {
        announcementManager.addLimitAnnouncements(true);
        favouritesManager.userId = null;
        favouritesManager.announcements = [];
        messengerRepository.clear();
        emit(AppUnAuthState());
      }
    });
  }
}
