import 'package:bloc/bloc.dart';
// import 'package:items_repository/items_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:items_repository/items_repository.dart';
import 'package:user_repository/user_repository.dart';

// State definitions
part 'activity_state.dart';

class ItemCubit extends Cubit<ItemState> {
  ItemCubit({
    required ItemsRepository itemsRepository,
    required UserRepository userRepository,
  })  : _itemsRepository = itemsRepository,
        _userRepository = userRepository,
        super(const ItemState.initial());

  final ItemsRepository _itemsRepository;
  final UserRepository _userRepository;

  bool isOwner(String itemUserID, String currentUserID) {
    return itemUserID == currentUserID;
  }

  User getUser() {
    return _userRepository.getCurrentUser();
  }

  Future<void> getItem(String itemID) async {
    emit(state.fromItemLoading());
    try {
      final item = await _itemsRepository.readItem(itemID);
      if (item.isEmpty) {
        emit(state.fromItemEmpty());
        return;
      }
      emit(state.fromItemLoaded(item));
    } on ItemFailure catch (failure) {
      emit(state.fromItemFailure(failure));
    }
  }

  void streamItem(String itemID) {
    emit(state.fromItemLoading());
    try {
      _itemsRepository.readItemStream(itemID).listen(
        (snapshot) {
          emit(state.fromItemLoaded(snapshot));
        },
        onError: (dynamic error) {
          emit(state.fromItemFailure(ItemFailure.fromGetItem()));
        },
      );
    } on ItemFailure catch (failure) {
      emit(state.fromItemFailure(failure));
    }
  }

  Future<void> editField(String itemID, String field, String data) async {
    await _itemsRepository.updateField(itemID, field, data);
  }

  Future<void> toggleLike(
    String userID,
    String itemID, {
    required bool liked,
  }) async {
    emit(state.fromItemLoading());
    try {
      await _itemsRepository.updateItemLikes(
        userID: userID,
        itemID: itemID,
        isLiked: liked,
      );
      await getItem(itemID);
      emit(state.fromItemToggle(liked: liked));
    } on ItemFailure catch (failure) {
      emit(state.fromItemFailure(failure));
    }
  }

  Future<void> deleteItem(
    String userID,
    String itemID,
    String photoURL,
  ) async {
    try {
      await _itemsRepository.deleteItem(userID, itemID, photoURL);
      emit(state.fromItemDeleted());
    } on ItemFailure catch (failure) {
      emit(state.fromItemFailure(failure));
    }
  }
}

extension _ItemStateExtensions on ItemState {
  ItemState fromItemLoading() => copyWith(status: ItemStatus.loading);

  ItemState fromItemEmpty() => copyWith(status: ItemStatus.empty);

  ItemState fromItemDeleted() => copyWith(status: ItemStatus.deleted);

  ItemState fromItemLoaded(Item item) => copyWith(
        status: ItemStatus.loaded,
        item: item,
      );

  // ItemState fromListLoaded(List<String> items) => copyWith(
  //       status: ItemStatus.loaded,
  //       items: items,
  //     );

  ItemState fromItemToggle({required bool liked}) => copyWith(
        status: ItemStatus.loaded,
        liked: liked,
      );

  ItemState fromItemFailure(ItemFailure failure) => copyWith(
        status: ItemStatus.failure,
        failure: failure,
      );
}
