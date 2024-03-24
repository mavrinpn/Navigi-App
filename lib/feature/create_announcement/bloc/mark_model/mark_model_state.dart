part of 'mark_model_cubit.dart';

abstract class MarkModelState {}

class MarkModelInitial extends MarkModelState {}

class MarkModelLoadingState extends MarkModelState {}

class MarkModelSuccessState extends MarkModelState {
  String? markName;
  String? modelName;
  MarkModelSuccessState({
    required this.markName,
    required this.modelName,
  });
}

class MarkModelFailState extends MarkModelState {}
