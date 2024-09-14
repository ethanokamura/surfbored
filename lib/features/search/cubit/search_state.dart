part of 'search_cubit.dart';

// Search States
abstract class PostSearchState {}

class PostSearchInitial extends PostSearchState {}

class PostSearchSuccess extends PostSearchState {
  PostSearchSuccess(this.results);
  final PostResults results;
}

class PostSearchFailure extends PostSearchState {
  PostSearchFailure(this.error);
  final String error;
}
