part of 'car_models_cubit.dart';

@immutable
abstract class CarModelsState {}

class CarModelsInitial extends CarModelsState {}

class ModelsLoadingState extends CarModelsState {
  final String markId;
  ModelsLoadingState(this.markId);
}

class ModelsSuccessState extends CarModelsState {
  final List<CarModel> models;

  ModelsSuccessState(this.models);
}

class MarksLoadingState extends CarModelsState {}

class MarksSuccessState extends CarModelsState {}