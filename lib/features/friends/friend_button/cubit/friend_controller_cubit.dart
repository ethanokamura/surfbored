import 'package:app_core/app_core.dart';
import 'package:friend_repository/friend_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'friend_controller_state.dart';

class FriendControllerCubit extends Cubit<FriendControllerState> {
  FriendControllerCubit(this._friendRepository)
      : super(const FriendControllerState.initial());

  final FriendRepository _friendRepository;

  Future<void> fetchFriendCount(String userID) async {
    final friends = await _friendRepository.fetchFriendCount(userID);
    emit(state.copyWith(friends: friends));
  }

  Future<void> fetchData(String userID) async {
    emit(state.fromLoading());
    try {
      final areFriends =
          await _friendRepository.areFriends(userID, UserRepository().user.id);
      if (areFriends) {
        emit(state.fromFriendAccepted());
        return;
      } else {
        final isRecipient = await _friendRepository.isRecipient(userID);
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

  Future<void> friendStateSelection(String userID) async {
    if (state.isRecieved) {
      await _friendRepository.addFriend(userID);
    } else if (state.areFriends) {
      await _friendRepository.removeFriend(userID);
    } else if (state.isRequested) {
      await _friendRepository.removeFriendRequest(userID);
    } else {
      await _friendRepository.sendFriendRequest(userID);
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
