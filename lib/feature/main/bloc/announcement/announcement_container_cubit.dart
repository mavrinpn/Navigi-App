import 'package:bloc/bloc.dart';

part 'announcement_container_state.dart';

class AnnouncementContainerCubit extends Cubit<AnnouncementContainerState> {
  AnnouncementContainerCubit() : super(AnnouncementContainerInitial());

  void reloadImages() {
    emit(AnnouncementContainerReloadImageState());
  }
}
