import 'package:app_core/app_core.dart';
import 'package:friend_repository/friend_repository.dart';
import 'package:user_repository/user_repository.dart';

// State definitions
part 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit({
    required UserRepository userRepository,
    required FriendRepository friendRepository,
  })  : _userRepository = userRepository,
        _friendRepository = friendRepository,
        super(const ActivityState.initial());

  final UserRepository _userRepository;
  final FriendRepository _friendRepository;

  Future<void> fetchUserActivity() async {
    final userId = _userRepository.user.id!;
    await fetchFriendRequests(userId);
    // get comments, likes, etc
    // sort by date
    // filter?
  }

  int currentPage = 0;
  final int pageSize = 10;
  bool hasMore = true;

  Future<void> fetchFriendRequests(int userId, {bool refresh = false}) async {
    if (refresh) {
      currentPage = 0;
      hasMore = true;
      emit(state.fromEmpty());
    }

    if (!hasMore) return;

    emit(state.fromLoading());
    try {
      final friendRequests = await _friendRepository.fetchPendingRequests(
        userId: userId,
        offset: currentPage * pageSize,
        limit: pageSize,
      );

      if (friendRequests.isEmpty) {
        hasMore = false; // No more boards to load
        emit(state.fromEmpty());
      } else {
        currentPage++; // Increment the page number
        emit(
          state.fromFriendRequestsLoaded(
            [...state.friendRequests, ...friendRequests],
          ),
        );
      }
    } on FriendFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }
}
