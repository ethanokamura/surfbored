import 'package:app_core/app_core.dart';
import 'package:friend_repository/friend_repository.dart';

part 'friend_count_state.dart';

class FriendCountCubit extends Cubit<FriendCountState> {
  FriendCountCubit(this._friendRepository)
      : super(const FriendCountState.initial());

  final FriendRepository _friendRepository;

  Future<void> fetchFriendCount(String userId) async {
    try {
      emit(state.fromLoading());
      final friends = await _friendRepository.fetchFriendCount(userId: userId);
      emit(state.fromLoaded(friends: friends));
    } on FriendFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }
}
