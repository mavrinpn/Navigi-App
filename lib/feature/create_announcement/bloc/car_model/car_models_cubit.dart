import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart/feature/create_announcement/data/car_marks_repository.dart';
import 'package:smart/feature/create_announcement/data/models/mark.dart';
import 'package:smart/feature/create_announcement/data/models/car_model.dart';

part 'car_models_state.dart';

class CarModelsCubit extends Cubit<CarModelsState> {
  CarMarksRepository carMarksRepository;

  CarModelsCubit(this.carMarksRepository) : super(CarModelsInitial());

  List<Mark> marks = [];

  CarModel? selectedModel;

  void getMarks(String subcategory) async {
    if (marks.isNotEmpty) return emit(MarksSuccessState());

    emit(MarksLoadingState());

    final original = await carMarksRepository.getMarks(subcategory);
    const subset = [
      'Audi',
      'BMW',
      'Hyundai',
      'Volkswagen',
      'Fiat',
      'Seat',
      'Citroen',
      'Renault',
      'Dacia',
      'Chevrolet',
      'Mercedes',
      'Toyota',
      'Skoda',
      'Nissan',
      'Opel',
      'Land Rover',
      'Suzuki',
    ];

    List<Mark> sortedSubset = original.where((item) => subset.contains(item.name)).toList()
      ..sort((a, b) => subset.indexOf(a.name).compareTo(subset.indexOf(b.name)));
    List<Mark> remainingElements = original.where((item) => !subset.contains(item.name)).toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    marks = [...sortedSubset, ...remainingElements];

    emit(MarksSuccessState());
  }

  void getModels({
    required String subcategory,
    required String mark,
  }) async {
    emit(ModelsLoadingState(mark));

    final models = await carMarksRepository.getModels(
      subcategory: subcategory,
      markId: mark,
    );
    emit(ModelsSuccessState(models));
  }
}
