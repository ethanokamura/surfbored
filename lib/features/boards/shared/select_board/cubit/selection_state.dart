part of 'selection_cubit.dart';

@immutable
abstract class SelectionState extends Equatable {
  const SelectionState();

  @override
  List<Object?> get props => [];
}

class SelectionInitial extends SelectionState {}

class SelectionLoading extends SelectionState {}

class SelectionSuccess extends SelectionState {
  const SelectionSuccess({required this.isSelected});
  final bool isSelected;
  @override
  List<Object?> get props => [isSelected];
}

class SelectionFailure extends SelectionState {
  const SelectionFailure({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
