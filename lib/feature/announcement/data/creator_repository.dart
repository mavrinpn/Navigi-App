import 'package:smart/models/announcement.dart';
import 'package:smart/services/database_service.dart';

class CreatorRepository {
  final DatabaseService databaseService;

  CreatorRepository({required this.databaseService});

  CreatorData? currentCreatorData;
  List<Announcement>? availableAnnouncements;
  List<Announcement>? soldAnnouncements;

  Future setCreator(CreatorData newCreator) async {
    currentCreatorData = newCreator;
    await _getAnnouncements();
  }

  Future _getAnnouncements() async {
    final announcements = await databaseService.getUserAnnouncements(
        userId: currentCreatorData!.uid);

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
