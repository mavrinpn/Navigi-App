import 'package:smart/models/announcement.dart';
import 'package:smart/models/user.dart';
import 'package:smart/services/database/database_service.dart';

class CreatorRepository {
  final DatabaseService databaseService;

  CreatorRepository({required this.databaseService});

  String? currentCreatorId;
  UserData? userData;
  List<Announcement>? availableAnnouncements;
  List<Announcement>? soldAnnouncements;

  Future setUserData(UserData user) async {
    userData = user;
  }

  Future setCreator(String newCreator) async {
    currentCreatorId = newCreator;
    await _getAnnouncements();
  }

  Future _getAnnouncements() async {
    final announcements = await databaseService.announcements.getUserAnnouncements(
        userId: currentCreatorId!);

    availableAnnouncements = [];
    soldAnnouncements = [];

    for (Announcement x in announcements){
      if (x.active){
        availableAnnouncements!.add(x);
      }
      else{
        soldAnnouncements!.add(x);
      }
    }
  }
}
