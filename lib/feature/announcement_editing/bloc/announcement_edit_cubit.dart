import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:smart/feature/announcement_editing/data/announcement_editing_repository.dart';
import 'package:smart/feature/announcement_editing/data/models/edit_data.dart';
import 'package:smart/feature/announcement_editing/data/models/image_data.dart';
import 'package:smart/managers/announcement_manager.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/services/parameters_parser.dart';
import 'package:smart/utils/price_type.dart';

part 'announcement_edit_state.dart';

class AnnouncementEditCubit extends Cubit<AnnouncementEditState> {
  AnnouncementEditingRepository repository;
  AnnouncementManager announcementManager;

  AnnouncementEditCubit(this.repository, this.announcementManager)
      : super(AnnouncementEditInitial());

  /// всю информацию на экране брать отсюда
  AnnouncementEditData get data => repository.editData!;

  List<ImageData> get images => repository.images.currentImages;

  /// Повесить на экран [PopScope] и вызывать когда он закрывается
  void closeEdit() => repository.closeEdit();

  Future<void> deleteAnnouncement(Announcement announcement) =>
      repository.deleteAnnouncement(announcement.id);

  /// Вызывать в initState экрана, либо если будет агрессировать то до пуша
  Future setAnnouncement(Announcement announcement) async {
    await repository.setAnnouncementForEdit(announcement);
    // print('announcement setted');
  }

  /// функция для onChange филда названия
  void onTitleChange(String? newTitle) {
    if (newTitle != null) repository.setTitle(newTitle);
  }

  void setParameterValue(String parameterKey, ParameterOption value) {
    for (SelectParameter parameter in []) {
      if (parameterKey == parameter.key) {
        parameter.setVariant(value);
        emit(AnnouncementChangeParameters());
        return;
      }
    }
  }

  void onDescriptionChanged(String? newDescription) {
    if (newDescription != null) {
      repository.setDescription(newDescription);
    }
  }

  void onPriceChanged(double? newPrice) {
    if (newPrice != null) {
      repository.setPrice(newPrice);
    }
  }

  void onPriceTypeChanged(PriceType? newPriceType) {
    if (newPriceType != null) {
      repository.setPriceType(newPriceType);
    }
  }

  /// вызывать на ту хуйню которая полу изображений
  void pickImages() async {
    await repository.pickImages();
    emit(AnnouncementChangeImages());
  }

  /// ну крестик на фотке
  void deleteImage(ImageData image) {
    repository.deleteImage(image);
    emit(AnnouncementChangeImages());
  }

  /// надеюсь понятно куда
  void saveChanges() async {
    emit(AnnouncementEditLoading());
    try {
      await repository.saveChanges();
      emit(AnnouncementEditSuccess());
    } catch (e) {
      emit(AnnouncementEditFail());
      rethrow;
    }
  }
}
