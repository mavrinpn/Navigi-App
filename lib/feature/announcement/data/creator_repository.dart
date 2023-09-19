import 'package:smart/models/announcement.dart';

class CreatorRepository {
  CreatorData? currentCreatorData;
  List<Announcement>? availableAnnouncements;
  List<Announcement>? soldAnnouncements;

  Future setCreator(CreatorData newCreator) async {
    currentCreatorData = newCreator;
  }
}