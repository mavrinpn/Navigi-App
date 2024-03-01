import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/feature/create_announcement/data/marks_repository.dart';
import 'package:smart/feature/create_announcement/data/models/mark.dart';
import 'package:smart/feature/create_announcement/data/models/mark_model.dart';

part 'select_mark_state.dart';

class SelectMarkCubit extends Cubit<SelectMarkState> {
  MarksRepository marksRepository;

  SelectMarkCubit(this.marksRepository) : super(SelectMarkInitial());

  String lastSubcategory = '';
  String lastMark = '';
  List<Mark> marks = [];
  List<MarkModel> models = [];

  void getMarks(String subcategory) async {
    if (subcategory == lastSubcategory) return emit(MarksGotState());

    emit(MarksLoadingState());
    lastSubcategory = subcategory;
    marks = await marksRepository.getMarks(subcategory);
    emit(MarksGotState());
  }

  void getModels(String subcategory, String mark) async {
    if (subcategory == lastSubcategory && mark == lastMark) {
      return emit(ModelsGotState(models, mark));
    }

    lastMark = mark;

    emit(ModelsLoadingState(mark));
    models =
        await marksRepository.getModels(subcategory: subcategory, markId: mark);
    emit(ModelsGotState(models, mark));
  }
}
