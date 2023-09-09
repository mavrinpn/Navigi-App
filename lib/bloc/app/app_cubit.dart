import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../enum/enum.dart';
import '../../feature/auth/data/auth_repository.dart';
import '../../managers/announcement_manager.dart';
import '../../managers/favourits_manager.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AuthRepository appRepository;
  AnnouncementManager announcementManager;
  FavouritesManager favouritesManager;

  AppCubit(
      {required this.appRepository,
      required this.announcementManager,
      required this.favouritesManager})
      : super(AppInitial()) {
    appRepository.appState.stream.listen((event) {
      if (event == AuthStateEnum.auth) {
        announcementManager.addLimitAnnouncements(true);
        favouritesManager.userId = appRepository.userId;
        favouritesManager.getFavourites();
        emit(AppAuthState());
      }
      if (event == AuthStateEnum.unAuth) {
        favouritesManager.userId = null;
        favouritesManager.announcements = [];
        emit(AppUnAuthState());
      }
    });
  }
}
