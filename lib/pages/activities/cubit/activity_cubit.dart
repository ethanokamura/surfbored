import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:items_repository/items_repository.dart';
import 'package:user_repository/user_repository.dart';

// State definitions
part 'activity_state.dart';

class ItemCubit extends Cubit<ItemState> {
  ItemCubit({
    required this.itemsRepository,
    required this.userRepository,
  }) : super(ItemInitial());

  final ItemsRepository itemsRepository;
  final UserRepository userRepository;

  bool isOwner(String itemUserID, String currentUserID) {
    return itemUserID == currentUserID;
  }

  User getUser() {
    return userRepository.getCurrentUser();
  }

  Future<Item> fetchItem(String itemID) async {
    try {
      final board = await itemsRepository.readItem(itemID);
      return board;
    } catch (e) {
      ItemError(message: 'error fetching board: $e');
      return Item.empty;
    }
  }

  Stream<ItemState> streamItem(String itemID) async* {
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

  Stream<ItemState> streamUserItems(String userID) async* {
    emit(UserItemsLoading());
    userRepository.readUserItemStream(userID).listen(
      (snapshot) {
        emit(UserItemsLoaded(items: snapshot));
      },
      onError: (dynamic error) {
        emit(ItemError(message: 'failed to load items: $error'));
      },
    );
  }

  Future<void> editField(String itemID, String field, String data) async {
    await itemsRepository.updateField(itemID, field, data);
  }

  Future<void> toggleLike(String userID, String itemID, bool isLiked) async {
    await itemsRepository.updateItemLikes(
      userID: userID,
      itemID: itemID,
      isLiked: isLiked,
    );
    await fetchItem(itemID);
    emit(ItemLiked(liked: isLiked));
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
