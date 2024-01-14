import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/feature/announcement_editing/data/announcement_editing_repository.dart';
import 'package:smart/feature/announcement_editing/data/models/edit_data.dart';
import 'package:smart/feature/announcement_editing/data/models/image_data.dart';
import 'package:smart/models/announcement.dart';

part 'announcement_edit_state.dart';

class AnnouncementEditCubit extends Cubit<AnnouncementEditState> {
  AnnouncementEditingRepository repository;

  AnnouncementEditCubit(this.repository) : super(AnnouncementEditInitial());

  /// всю информацию на экране брать отсюда
  AnnouncementEditData get data => repository.editData!;

  /// Повесить на экран [PopScope] и вызывать когда он закрывается
  void closeEdit() => repository.closeEdit();

  /// Вызывать в initState экрана, либо если будет агрессировать то до пуша
  void setAnnouncement(Announcement announcement) =>
      repository.setAnnouncementForEdit(announcement);

  /// функция для onChange филда названия
  void onTitleChange(String? newTitle) {
    if (newTitle != null) repository.setTitle(newTitle);
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
