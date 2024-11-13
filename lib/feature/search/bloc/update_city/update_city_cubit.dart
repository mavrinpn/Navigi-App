import 'package:bloc/bloc.dart';

part 'update_city_state.dart';

class UpdateCityCubit extends Cubit<UpdateCityState> {
  UpdateCityCubit(super.initialState);

  void needUpdateCity({String? title}) {
    emit(UpdateCityState());
  }
}
