part of 'select_mark_cubit.dart';

@immutable
abstract class SelectMarkState {}

class SelectMarkInitial extends SelectMarkState {}

class MarksLoadingState extends SelectMarkState {}

class MarksGotState extends SelectMarkState {}

class ModelsLoadingState extends SelectMarkState {}

class ModelsGotState extends SelectMarkState {
  final List<MarkModel> models;

  ModelsGotState(this.models);
}