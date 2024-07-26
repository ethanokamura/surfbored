import 'package:bloc/bloc.dart';
import 'package:boards_repository/boards_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:items_repository/items_repository.dart';
import 'package:user_repository/user_repository.dart';

// State definitions
part 'activity_state.dart';

class ItemCubit extends Cubit<ItemState> {
  ItemCubit({
    required this.itemsRepository,
    required this.userRepository,
    required this.boardsRepository,
  }) : super(ItemInitial());

  final ItemsRepository itemsRepository;
  final UserRepository userRepository;
  final BoardsRepository boardsRepository;

  bool isOwner(String itemUserID, String currentUserID) {
    return itemUserID == currentUserID;
  }

  User getUser() {
    return userRepository.getCurrentUser();
  }

  Future<Item> fetchItem(String itemID) async {
    try {
      final item = await itemsRepository.readItem(itemID);
      return item;
    } catch (e) {
      ItemError(message: 'error fetching board: $e');
      return Item.empty;
    }
  }

  void streamItem(String itemID) {
    emit(ItemLoading());
    itemsRepository.readItemStream(itemID).listen(
      (snapshot) {
        emit(ItemLoaded(item: snapshot));
      },
      onError: (dynamic error) {
        emit(ItemError(message: 'failed to load items: $error'));
      },
    );
  }

  void streamBoardItems(String boardID) {
    emit(ItemsLoading());
    boardsRepository.readItemsStream(boardID).listen(
      (snapshot) {
        emit(ItemsLoaded(items: snapshot));
      },
      onError: (dynamic error) {
        emit(ItemError(message: 'failed to stream items $error'));
      },
    );
  }

  void streamUserItems(String userID) {
    emit(ItemsLoading());
    userRepository.readUserItemStream(userID).listen(
      (snapshot) {
        emit(ItemsLoaded(items: snapshot));
      },
      onError: (dynamic error) {
        emit(ItemError(message: 'failed to load items: $error'));
      },
    );
  }

  Future<void> editField(String itemID, String field, String data) async {
    await itemsRepository.updateField(itemID, field, data);
  }

  Future<void> toggleLike(
    String userID,
    String itemID, {
    required bool isLiked,
  }) async {
    await itemsRepository.updateItemLikes(
      userID: userID,
      itemID: itemID,
      isLiked: isLiked,
    );
    final updatedItem = await fetchItem(itemID);
    emit(ItemLoaded(item: updatedItem));
  }

  Future<void> deleteItem(String userID, String itemID, String photoURL) async {
    try {
      await itemsRepository.deleteItem(userID, itemID, photoURL);
      emit(ItemDeleted());
    } catch (e) {
      emit(ItemError(message: 'failed to delete item'));
    }
  }
}
