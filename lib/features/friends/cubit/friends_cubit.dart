import 'package:app_core/app_core.dart';
import 'package:friend_repository/friend_repository.dart';

part 'friends_state.dart';

class FriendsCubit extends Cubit<FriendsState> {
  FriendsCubit(this._friendRepository) : super(const FriendsState.initial());

  final FriendRepository _friendRepository;

  int currentPage = 0;
  final int pageSize = 10;
  bool hasMore = true;
  bool remove = true;

  Future<void> fetchFriends(int userId, {bool refresh = false}) async {
    if (refresh) {
      currentPage = 0;
      hasMore = true;
      emit(state.fromEmpty());
    }

    if (!hasMore) return;

    emit(state.fromLoading());
    try {
      final friends = await _friendRepository.fetchFriends(
        userId: userId,
        offset: currentPage * pageSize,
        limit: pageSize,
      );

      if (friends.isEmpty) {
        hasMore = false; // No more boards to load
        emit(state.fromEmpty());
      } else {
        currentPage++; // Increment the page number
        emit(state.fromLoaded([...state.friends, ...friends]));
      }
    } on FriendFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  Future<void> modifiyFriend(int currentUserId, int userId) async {
    if (remove) {
      await _friendRepository.removeFriend(
        currentUserId: currentUserId,
        otherUserId: userId,
      );
    } else {
      await _friendRepository.sendFriendRequest(
        senderId: currentUserId,
        recipientId: userId,
      );
    }
    remove = !remove;
  }
}
