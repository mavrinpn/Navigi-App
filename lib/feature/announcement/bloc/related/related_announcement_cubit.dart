import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart/managers/announcement_manager.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/services/filters/filter_dto.dart';

part 'related_announcement_state.dart';

class RelatedAnnouncementCubit extends Cubit<RelatedAnnouncementState> {
  final AnnouncementManager _announcementManager;

  RelatedAnnouncementCubit({
    required AnnouncementManager announcementManager,
  })  : _announcementManager = announcementManager,
        super(RelatedAnnouncementInitial());

  void load({
    required String subcategoryId,
    required double minPrice,
    required double maxPrice,
    required String excludeId,
    required String model,
    required String type,
    List<Parameter>? parameters,
  }) async {
    emit(RelatedAnnouncementsLoadingState());
    try {
      final filter = SubcategoryFilterDTO(
        // minPrice: minPrice,
        // maxPrice: maxPrice,
        subcategory: subcategoryId,
        parameters: parameters ?? [],
        limit: 6,
        excludeId: excludeId,
        model: model,
        type: type,
      );

      final res =
          await _announcementManager.dbService.announcements.searchAnnouncementsInSubcategory(filterData: filter);

      emit(RelatedAnnouncementsSuccessState(announcements: res.list));
    } catch (e) {
      emit(RelatedAnnouncementsFailState());
      rethrow;
    }
  }
}
