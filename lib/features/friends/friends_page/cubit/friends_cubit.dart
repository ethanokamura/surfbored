import 'package:app_core/app_core.dart';
import 'package:friend_repository/friend_repository.dart';

part 'friends_state.dart';

/// Manages the state and logic for friend-related operations.
class FriendsCubit extends Cubit<FriendsState> {
  /// Creates a new instance of [FriendsCubit].
  /// Requires a [FriendRepository] to handle data operations.
  FriendsCubit(this._friendRepository) : super(const FriendsState.initial());

  final FriendRepository _friendRepository;

  int _currentPage = 0;
  final int _pageSize = 10;
  bool _hasMore = true;
  bool _remove = true;

  bool get hasMore => _hasMore;
  bool get remove => _remove;

  /// Fetches boards for a specific user.
  /// If [refresh] is true, resets pagination and fetches from the beginning.
  /// Implements pagination, fetching [_pageSize] boards at a time.
  Future<void> fetchFriends(String userId, {bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMore = true;
      emit(state.fromEmpty());
    }

    if (!_hasMore) return;

    emit(state.fromLoading());
    try {
      final friends = await _friendRepository.fetchFriends(
        userId: userId,
        offset: _currentPage * _pageSize,
        limit: _pageSize,
      );

      if (friends.isEmpty) {
        _hasMore = false; // No more boards to load
        emit(state.fromEmpty());
      } else {
        _currentPage++; // Increment the page number
        emit(state.fromLoaded([...state.friends, ...friends]));
      }
    } on FriendFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  /// Modifies friend status
  /// TODO(Ethan): remove?
  Future<void> modifiyFriend(String currentUserId, String userId) async {
    if (_remove) {
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
    _remove = !_remove;
  }
}
