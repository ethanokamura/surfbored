import 'package:app_core/app_core.dart';
import 'package:user_repository/user_repository.dart';

part 'friend_controller_state.dart';

class FriendControllerCubit extends Cubit<FriendControllerState> {
  FriendControllerCubit(this._userRepository)
      : super(const FriendControllerState.initial());

  final UserRepository _userRepository;

  Future<void> fetchFriendCount(String userID) async {
    final friends = await _userRepository.fetchFriendCount(userID);
    emit(state.copyWith(friends: friends));
  }

  Future<void> fetchData(String userID) async {
    emit(state.fromLoading());
    try {
      final areFriends = await _userRepository.areUsersFriends(userID);
      if (areFriends) {
        emit(state.fromFriendAccepted());
        return;
      } else {
        final sender = await _userRepository.fetchRequestSender(userID);
        sender == null
            ? emit(state.fromNoRequest())
            : sender == userID
                ? emit(state.fromRequestRecieved())
                : emit(state.fromRequestSent());
      }
    } catch (e) {
      emit(state.fromFailure());
    }
  }

  Future<void> friendStateSelection(String userID) async {
    if (state.isRecieved || state.areFriends) {
      await _userRepository.modifyFriend(userID);
    } else {
      await _userRepository.modifyFriendRequest(userID);
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
