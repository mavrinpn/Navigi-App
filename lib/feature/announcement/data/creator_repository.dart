import 'package:smart/models/announcement.dart';
import 'package:smart/models/user.dart';
import 'package:smart/services/database/database_service.dart';

class CreatorRepository {
  final DatabaseService databaseService;

  CreatorRepository({required this.databaseService});

  String? currentCreatorId;
  UserData? userData;
  List<Announcement> availableAnnouncements = [];
  List<Announcement> soldAnnouncements = [];

  setUserData(UserData user) {
    userData = user;
  }

  Future setCreator(String newCreator) async {
    currentCreatorId = newCreator;
    await _getAnnouncements();
  }

  Future _getAnnouncements() async {
    final announcements = await databaseService.announcements.getUserAnnouncements(
        userId: currentCreatorId!);

    availableAnnouncements.clear();
    soldAnnouncements.clear();

    for (Announcement announcement in announcements){
      if (announcement.active){
        availableAnnouncements.add(announcement);
      }
      else{
        soldAnnouncements.add(announcement);
      }
    }
  }
}
