import 'package:bloc/bloc.dart';
import 'package:smart/managers/mark_model_manager.dart';

part 'mark_model_state.dart';

class MarkModelCubit extends Cubit<MarkModelState> {
  final MarkModelManager markModelManager;

  MarkModelCubit({
    required this.markModelManager,
  }) : super(MarkModelInitial());

  void load({
    required String markId,
    required String modelId,
  }) async {
    emit(MarkModelLoadingState());
    try {
      final markName = await markModelManager.getMarkNameById(markId);
      final modelName = await markModelManager.getModelNameById(modelId);
      emit(MarkModelSuccessState(
        markName: markName,
        modelName: modelName,
      ));
    } catch (e) {
      emit(MarkModelFailState());
      rethrow;
    }
  }
}
