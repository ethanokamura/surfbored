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

  Future<void> fetchUserActivity(String userID) async {
    await fetchFriendRequests();
    // get comments, likes, etc
    // sort by date
    // filter?
  }

  Future<void> fetchFriendRequests() async {
    try {
      final senderIDs = await _friendRepository.fetchPendingRequests(
        userId: _userRepository.user.id,
      );
      if (senderIDs.isEmpty) {
        emit(state.fromEmpty());
      } else {
        emit(state.fromFriendRequestsLoaded(senderIDs));
      }
    } on UserFailure {
      emit(state.fromFailure(UserFailure.fromGetUser()));
    }
  }
}
