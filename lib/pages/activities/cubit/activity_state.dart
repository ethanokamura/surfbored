// part of 'activity_cubit.dart';

// import 'package:items_repository/items_repository.dart';

// abstract class ItemState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

// class ItemInitial extends ItemState {}

// class ItemLoading extends ItemState {}

// class ItemsLoading extends ItemState {}

// class ItemDeleted extends ItemState {}

// class ItemLiked extends ItemState {
//   ItemLiked({required this.liked});
//   final bool liked;

//   @override
//   List<Object?> get props => [liked];
// }

// class ItemLoaded extends ItemState {
//   ItemLoaded({required this.item});
//   final Item item;

//   @override
//   List<Object?> get props => [item];
// }

// class ItemsLoaded extends ItemState {
//   ItemsLoaded({required this.items});
//   final List<String> items;

//   @override
//   List<Object?> get props => [items];
// }

// class ItemError extends ItemState {
//   ItemError({required this.message});
//   final String message;

//   @override
//   List<Object?> get props => [message];
// }

part of 'activity_cubit.dart';

enum ItemStatus { initial, loading, empty, loaded, deleted, failure }

final class ItemState extends Equatable {
  const ItemState._({
    this.status = ItemStatus.initial,
    this.item = Item.empty,
    // this.items = const [],
    this.failure = ItemFailure.empty,
    this.liked = false,
  });

  const ItemState.initial() : this._();

  final ItemStatus status;
  final Item item;
  // final List<String> items;
  final ItemFailure failure;
  final bool liked;

  @override
  List<Object?> get props => [
        status,
        item,
        // items,
        failure,
        liked,
      ];

  ItemState copyWith({
    ItemStatus? status,
    Item? item,
    // List<String>? items,
    ItemFailure? failure,
    bool? liked,
  }) {
    return ItemState._(
      status: status ?? this.status,
      item: item ?? this.item,
      // items: items ?? this.items,
      failure: failure ?? this.failure,
      liked: liked ?? this.liked,
    );
  }
}

extension BoardStateExtensions on ItemState {
  bool get isEmpty => status == ItemStatus.empty;
  bool get isLoaded => status == ItemStatus.loaded;
  bool get isLoading => status == ItemStatus.loading;
  bool get isFailure => status == ItemStatus.failure;
}
