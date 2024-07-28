import 'dart:io';

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

  void streamAllItems() {
    emit(state.fromItemsLoading());
    try {
      _itemsRepository.streamItems().listen(
        (items) {
          emit(state.fromItemsLoaded(items));
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

  Future<void> createItem({
    required String userID,
    required String title,
    required String description,
    required List<String> tags,
    required File? imageFile,
  }) async {
    emit(state.fromItemCreating());
    try {
      final docID = await _itemsRepository.createItem(
        Item(
          title: title,
          description: description,
          uid: 'userId', // Replace with actual user ID
          tags: tags,
        ),
        userID,
      );
      if (imageFile != null) {
        await _itemsRepository.uploadImage(imageFile, docID);
      }
      emit(state.fromItemCreated());
      await getItem(docID);
    } on ItemFailure catch (failure) {
      emit(state.fromItemFailure(failure));
    }
  }

  Future<void> deleteItem(
    String userID,
    String itemID,
    String photoURL,
  ) async {
    emit(state.fromItemLoading());
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

  ItemState fromItemsLoading() => copyWith(status: ItemStatus.loading);

  ItemState fromItemEmpty() => copyWith(status: ItemStatus.empty);

  ItemState fromItemDeleted() => copyWith(status: ItemStatus.deleted);

  ItemState fromItemCreating() => copyWith(status: ItemStatus.creating);

  ItemState fromItemCreated() => copyWith(status: ItemStatus.created);

  ItemState fromItemLoaded(Item item) => copyWith(
        status: ItemStatus.loaded,
        item: item,
      );

  ItemState fromItemsLoaded(List<Item> items) => copyWith(
        status: ItemStatus.loaded,
        items: items,
      );

  ItemState fromItemToggle({required bool liked}) => copyWith(
        status: ItemStatus.loaded,
        liked: liked,
      );

  ItemState fromItemFailure(ItemFailure failure) => copyWith(
        status: ItemStatus.failure,
        failure: failure,
      );
}
