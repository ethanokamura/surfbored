part of 'board_cubit.dart';

abstract class BoardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BoardInitial extends BoardState {}

class BoardLoading extends BoardState {}

class UserBoardsLoading extends BoardState {}

class BoardDeleted extends BoardState {}

class BoardLiked extends BoardState {
  BoardLiked({required this.liked});
  final bool liked;

  @override
  List<Object?> get props => [liked];
}

class BoardLoaded extends BoardState {
  BoardLoaded({required this.board});
  final Board board;

  @override
  List<Object?> get props => [board];
}

class UserBoardsLoaded extends BoardState {
  UserBoardsLoaded({required this.boards});
  final List<String> boards;

  @override
  List<Object?> get props => [boards];
}

class BoardItemsLoaded extends BoardState {
  BoardItemsLoaded({required this.items});
  final List<String> items;

  @override
  List<Object?> get props => [items];
}

class BoardError extends BoardState {
  BoardError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
