part of 'add_activity_cubit.dart';

abstract class AddActivityState extends Equatable {
  const AddActivityState();

  @override
  List<Object> get props => [];
}

class BoardInitial extends AddActivityState {}

class BoardLoading extends AddActivityState {}

class BoardLoaded extends AddActivityState {
  const BoardLoaded({required this.board});
  final Board board;

  @override
  List<Object> get props => [board];
}

class BoardsLoaded extends AddActivityState {
  const BoardsLoaded({required this.boards});
  final List<String> boards;

  @override
  List<Object> get props => [boards];
}

class BoardError extends AddActivityState {
  const BoardError({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

class BoardItemToggled extends AddActivityState {
  const BoardItemToggled({required this.isSelected});
  final bool isSelected;

  @override
  List<Object> get props => [isSelected];
}

class BoardItemChecked extends AddActivityState {
  const BoardItemChecked({required this.isIncluded});
  final bool isIncluded;

  @override
  List<Object> get props => [isIncluded];
}
