part of 'select_mark_cubit.dart';

@immutable
abstract class SelectMarkState {}

class SelectMarkInitial extends SelectMarkState {}

class MarksLoadingState extends SelectMarkState {}

class MarksGotState extends SelectMarkState {}

class ModelsLoadingState extends SelectMarkState {
  final String markId;
  ModelsLoadingState(this.markId);
}

class ModelsGotState extends SelectMarkState {
  final String markId;
  final List<MarkModel> models;

  ModelsGotState(this.models, this.markId);
}