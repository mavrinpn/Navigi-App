part of 'popular_queries_cubit.dart';

@immutable
abstract class PopularQueriesState {}

class PopularQueriesInitial extends PopularQueriesState {}

class PopularQueriesSuccess extends PopularQueriesState {}

class PopularQueriesFail extends PopularQueriesState {}

class PopularQueriesLoading extends PopularQueriesState {}
