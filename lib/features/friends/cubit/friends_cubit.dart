import 'package:app_core/app_core.dart';
import 'package:friend_repository/friend_repository.dart';

part 'friends_state.dart';

class FriendsCubit extends Cubit<FriendsState> {
  FriendsCubit(this._friendRepository) : super(const FriendsState.initial());

  final FriendRepository _friendRepository;

  int _currentPage = 0;
  final int _pageSize = 10;
  bool _hasMore = true;

  bool hasMore() {
    return _hasMore;
  }

  Future<List<String>> fetchFriends(String userId) async =>
      _friendRepository.fetchFriends(userId: userId);

  // Future<void> modifiyFriend(String userID) async {
  //   await _friendRepository.modifyFriend(userID);
  // }
}
