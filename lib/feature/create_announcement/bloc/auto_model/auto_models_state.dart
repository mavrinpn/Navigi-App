part of 'auto_models_cubit.dart';

@immutable
abstract class AutoModelsState {}

class AutoModelsInitial extends AutoModelsState {}

class ModelsLoadingState extends AutoModelsState {}

class ModelsSuccessState extends AutoModelsState {
  final List<AutoModel> models;

  ModelsSuccessState(this.models);
}

class MarksLoadingState extends AutoModelsState {}

class MarksSuccessState extends AutoModelsState {}
