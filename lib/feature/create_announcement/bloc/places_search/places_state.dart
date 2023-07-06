part of 'places_cubit.dart';

@immutable
abstract class PlacesState {}

class PlacesInitial extends PlacesState {}

class PlacesLoadingState extends PlacesState {}

class PlacesSuccessState extends PlacesState {}

class PlacesEmptyState extends PlacesState {}

class PlacesFailState extends PlacesState {}
