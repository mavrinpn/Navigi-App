part of 'announcement_edit_cubit.dart';

@immutable
abstract class AnnouncementEditState {}

class AnnouncementEditInitial extends AnnouncementEditState {}

class AnnouncementEditLoading extends AnnouncementEditState {}

class AnnouncementEditSuccess extends AnnouncementEditState {}

class AnnouncementEditFail extends AnnouncementEditState {}

class AnnouncementChangeImages extends AnnouncementEditState {}
