import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/feature/announcement_editing/data/announcement_editing_repository.dart';
import 'package:smart/feature/announcement_editing/data/models/edit_data.dart';
import 'package:smart/feature/announcement_editing/data/models/image_data.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/models/item/item.dart';

part 'announcement_edit_state.dart';

class AnnouncementEditCubit extends Cubit<AnnouncementEditState> {
  AnnouncementEditingRepository repository;

  AnnouncementEditCubit(this.repository) : super(AnnouncementEditInitial());

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
    print('announcement setted');
  }

  /// функция для onChange филда названия
  void onTitleChange(String? newTitle) {
    if (newTitle != null) repository.setTitle(newTitle);
  }

  void setParameterValue(String parameterKey, String value) {
    for (Parameter parameter in data.parameters!.variableParametersList) {
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

  void onPriceChanged(String? newPrice) {
    if (newPrice != null && double.tryParse(newPrice) != null) {
      repository.setPrice(double.parse(newPrice));
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
