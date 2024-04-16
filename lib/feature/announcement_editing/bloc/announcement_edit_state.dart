// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'announcement_edit_cubit.dart';

@immutable
abstract class AnnouncementEditState {}

class AnnouncementEditInitial extends AnnouncementEditState {}

class AnnouncementEditLoading extends AnnouncementEditState {}

class AnnouncementEditSuccess extends AnnouncementEditState {}

class AnnouncementEditFail extends AnnouncementEditState {
  final String error;
  AnnouncementEditFail({
    required this.error,
  });
}

class AnnouncementChangeImages extends AnnouncementEditState {}

class AnnouncementChangeParameters extends AnnouncementEditState {}
