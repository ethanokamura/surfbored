import 'package:app_core/app_core.dart';
import 'package:friend_repository/friend_repository.dart';

part 'friend_count_state.dart';

/// Manages the state and logic for friend count operations.
class FriendCountCubit extends Cubit<FriendCountState> {
  /// Creates a new instance of [FriendCountCubit].
  /// Requires a [FriendRepository] to handle data operations.
  FriendCountCubit(this._friendRepository)
      : super(const FriendCountState.initial());

  final FriendRepository _friendRepository;

  /// Fetches the current amount of friends the given user has
  /// Requires the [userId] of the targeted user
  Future<void> fetchFriendCount({required String userId}) async {
    try {
      emit(state.fromLoading());
      final friends = await _friendRepository.fetchFriendCount(userId: userId);
      emit(state.fromLoaded(friends: friends));
    } on FriendFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }
}
