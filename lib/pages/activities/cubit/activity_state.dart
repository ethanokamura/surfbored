part of 'activity_cubit.dart';

abstract class ItemState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemsLoading extends ItemState {}

class ItemDeleted extends ItemState {}

class ItemLiked extends ItemState {
  ItemLiked({required this.liked});
  final bool liked;

  @override
  List<Object?> get props => [liked];
}

class ItemLoaded extends ItemState {
  ItemLoaded({required this.item});
  final Item item;

  @override
  List<Object?> get props => [item];
}

class ItemsLoaded extends ItemState {
  ItemsLoaded({required this.items});
  final List<String> items;

  @override
  List<Object?> get props => [items];
}

class ItemError extends ItemState {
  ItemError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
