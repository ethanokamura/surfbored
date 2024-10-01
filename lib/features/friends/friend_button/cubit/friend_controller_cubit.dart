import 'package:app_core/app_core.dart';
import 'package:friend_repository/friend_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'friend_controller_state.dart';

class FriendControllerCubit extends Cubit<FriendControllerState> {
  FriendControllerCubit(this._friendRepository)
      : super(const FriendControllerState.initial());

  final FriendRepository _friendRepository;

  Future<void> fetchFriendCount(String userId) async {
    final friends = await _friendRepository.fetchFriendCount(userId: userId);
    emit(state.copyWith(friends: friends));
  }

  Future<void> fetchData(String userId) async {
    emit(state.fromLoading());
    try {
      final areFriends = await _friendRepository.areFriends(
        userAId: userId,
        userBId: UserRepository().user.id,
      );
      if (areFriends) {
        emit(state.fromFriendAccepted());
        return;
      } else {
        final isRecipient = await _friendRepository.isRecipient(userId: userId);
        isRecipient == null
            ? emit(state.fromNoRequest())
            : isRecipient
                ? emit(state.fromRequestRecieved())
                : emit(state.fromRequestSent());
      }
    } catch (e) {
      emit(state.fromFailure());
    }
  }

  Future<void> friendStateSelection(String userId) async {
    if (state.isRecieved) {
      await _friendRepository.addFriend(otherUserId: userId);
    } else if (state.areFriends) {
      await _friendRepository.removeFriend(otherUserId: userId);
    } else if (state.isRequested) {
      await _friendRepository.removeFriendRequest(otherUserId: userId);
    } else {
      await _friendRepository.sendFriendRequest(recipientId: userId);
    }
    updateState();
  }

  void updateState() {
    if (state.isRecieved) {
      emit(state.fromFriendAccepted());
    } else if (state.areFriends) {
      emit(state.fromNoRequest());
    } else if (state.isRequested) {
      emit(state.fromNoRequest());
    } else {
      emit(state.fromRequestSent());
    }
  }
}
