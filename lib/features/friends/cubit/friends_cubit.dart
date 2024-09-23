import 'package:app_core/app_core.dart';
import 'package:user_repository/user_repository.dart';

part 'friends_state.dart';

class FriendsCubit extends Cubit<FriendsState> {
  FriendsCubit(this._userRepository) : super(const FriendsState.initial());

  final UserRepository _userRepository;

  int _currentPage = 0;
  final int _pageSize = 10;
  bool _hasMore = true;

  bool hasMore() {
    return _hasMore;
  }

  void streamFriends(String userID) {
    emit(state.fromLoading());
    _currentPage = 0;
    _hasMore = true;
    _loadMoreFriends(userID, reset: true);
  }

  void loadMoreFriends(String userID) {
    if (_hasMore) {
      _currentPage++;
      _loadMoreFriends(userID);
    }
  }

  void _loadMoreFriends(String userID, {bool reset = false}) {
    try {
      _userRepository
          .streamFriends(userID, pageSize: _pageSize, page: _currentPage)
          .listen(
        (friends) {
          if (friends.isEmpty) {
            emit(state.fromEmpty());
            return;
          }
          if (friends.length < _pageSize) {
            _hasMore = false;
          }
          if (reset) {
            emit(state.fromLoaded(friends));
          } else {
            emit(state.fromLoaded(List.of(state.friends)..addAll(friends)));
          }
        },
        onError: (error) {
          emit(state.fromEmpty());
        },
      );
    } on UserFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  Future<void> modifiyFriend(String userID) async {
    await _userRepository.modifyFriend(userID);
  }
}
