import 'package:app_core/app_core.dart';
import 'package:friend_repository/friend_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'friend_button_state.dart';

class FriendButtonCubit extends Cubit<FriendButtonState> {
  FriendButtonCubit(this._friendRepository)
      : super(const FriendButtonState.initial());

  final FriendRepository _friendRepository;

  Future<void> fetchData(String userId) async {
    final currentUser = UserRepository().user.uuid;
    emit(state.fromLoading());
    try {
      final areFriends = await _friendRepository.areFriends(
        userAId: userId,
        userBId: currentUser,
      );
      if (areFriends) {
        emit(state.fromFriendAccepted());
        return;
      } else {
        final isRecipient = await _friendRepository.isRecipient(
          currentUserId: currentUser,
          userId: userId,
        );
        isRecipient == null
            ? emit(state.fromNoRequest())
            : isRecipient
                ? emit(state.fromRequestRecieved())
                : emit(state.fromRequestSent());
      }
    } on FriendFailure catch (failure) {
      print(failure);
      emit(state.fromFailure(failure));
    }
  }

  Future<void> friendStateSelection(String userId) async {
    final currentUser = UserRepository().user.uuid;
    emit(state.fromLoading());
    try {
      if (state.friendStatus == FriendStatus.recieved) {
        await _friendRepository.addFriend(
          otherUserId: userId,
          currentUserId: currentUser,
        );
      } else if (state.friendStatus == FriendStatus.friends) {
        await _friendRepository.removeFriend(
          otherUserId: userId,
          currentUserId: currentUser,
        );
      } else if (state.friendStatus == FriendStatus.requested) {
        await _friendRepository.removeFriendRequest(
          otherUserId: userId,
          currentUserId: currentUser,
        );
      } else {
        await _friendRepository.sendFriendRequest(
          recipientId: userId,
          senderId: currentUser,
        );
      }
      _updateState();
    } on FriendFailure catch (failure) {
      print(failure);
      emit(state.fromFailure(failure));
    }
  }

  void _updateState() {
    if (state.friendStatus == FriendStatus.recieved) {
      emit(state.fromFriendAccepted());
    } else if (state.friendStatus == FriendStatus.friends) {
      emit(state.fromNoRequest());
    } else if (state.friendStatus == FriendStatus.requested) {
      emit(state.fromNoRequest());
    } else {
      emit(state.fromRequestSent());
    }
  }
}
