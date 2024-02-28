import 'package:bloc/bloc.dart';

part 'update_appbar_filter_state.dart';

class UpdateAppBarFilterCubit extends Cubit<UpdateAppBarFilterState> {
  UpdateAppBarFilterCubit(super.initialState);

  void needUpdateAppBarFilters() {
    emit(UpdateAppBarFilterState(needUpdate: true));
  }
}
