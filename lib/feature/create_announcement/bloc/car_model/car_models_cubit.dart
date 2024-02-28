import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/feature/create_announcement/data/auto_repository.dart';
import 'package:smart/feature/create_announcement/data/models/auto_marks.dart';
import 'package:smart/feature/create_announcement/data/models/auto_model.dart';

part 'car_models_state.dart';

class CarModelsCubit extends Cubit<CarModelsState> {
  AutoMarksRepository autoMarksRepository;

  CarModelsCubit(this.autoMarksRepository) : super(CarModelsInitial());

  List<Mark> marks = [];

  AutoModel? selectedModel;

  void getMarks() async {
    if (marks.isNotEmpty) return emit(MarksSuccessState());

    emit(MarksLoadingState());
    marks = await autoMarksRepository.getMarks();
    emit(MarksSuccessState());
  }

  void getModels(String mark) async {
    emit(ModelsLoadingState());

    final models = await autoMarksRepository.getModels(mark);
    emit(ModelsSuccessState(models));
  }
}
