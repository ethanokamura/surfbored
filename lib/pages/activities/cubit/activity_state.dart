part of 'activity_cubit.dart';

enum ItemStatus {
  initial,
  loading,
  empty,
  loaded,
  deleted,
  created,
  creating,
  failure,
}

final class ItemState extends Equatable {
  const ItemState._({
    this.status = ItemStatus.initial,
    this.item = Item.empty,
    this.items = const [],
    this.failure = ItemFailure.empty,
    this.liked = false,
  });

  const ItemState.initial() : this._();

  final ItemStatus status;
  final Item item;
  final List<Item> items;
  final ItemFailure failure;
  final bool liked;

  @override
  List<Object?> get props => [
        status,
        item,
        items,
        failure,
        liked,
      ];

  ItemState copyWith({
    ItemStatus? status,
    Item? item,
    List<Item>? items,
    ItemFailure? failure,
    bool? liked,
  }) {
    return ItemState._(
      status: status ?? this.status,
      item: item ?? this.item,
      items: items ?? this.items,
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
  bool get isCreated => status == ItemStatus.created;
  bool get isCreating => status == ItemStatus.creating;
}
