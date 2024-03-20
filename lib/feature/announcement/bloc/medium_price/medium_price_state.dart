part of 'medium_price_cubit.dart';

abstract class MediumPriceState extends Equatable {}

class MediumPriceInitial extends MediumPriceState {
  @override
  List<Object?> get props => [];
}

class MediumPriceLoadingState extends MediumPriceState {
  @override
  List<Object?> get props => [];
}

class MediumPriceEmptyState extends MediumPriceState {
  @override
  List<Object?> get props => [];
}

class MediumPriceSuccessState extends MediumPriceState {
  final int mediumPrice;

  MediumPriceSuccessState({required this.mediumPrice});
  @override
  List<Object?> get props => [mediumPrice];
}

class MediumPriceFailState extends MediumPriceState {
  @override
  List<Object?> get props => [];
}
