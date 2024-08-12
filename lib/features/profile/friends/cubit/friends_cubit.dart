import 'package:app_core/app_core.dart';
import 'package:user_repository/user_repository.dart';

part 'friends_state.dart';

class FriendCubit extends Cubit<FriendState> {
  FriendCubit(this._userRepository) : super(const FriendState.initial());

  final UserRepository _userRepository;

  Future<void> fetchData(String userID) async {
    emit(state.fromLoading());
    try {
      final friends = await _userRepository.fetchFriendCount(userID);
      final areFriends = await _userRepository.areUsersFriends(userID);

      if (areFriends) {
        print('users are friends');
        emit(state.fromFriendAccepted());
      } else {
        final sender = await _userRepository.fetchRequestSender(userID);
        if (sender == null) {
          print('no request found');
          emit(state.fromNoRequest());
        } else {
          if (sender == userID) {
            print('user is reciever');
            emit(state.fromRequestRecieved());
          } else {
            print('user is sender');
            emit(state.fromRequestSent());
          }
        }
      }
      emit(state.copyWith(friends: friends));
    } catch (e) {
      emit(state.fromFailure());
    }
  }

  Future<void> friendStateSelection(String userID) async {
    if (state.isRecieved) {
      await _userRepository.modifyFriend(userID, 1);
    } else if (state.isRequested) {
      await _userRepository.modifyFriendRequest(userID, removed: false);
    } else if (state.areFriends) {
      await _userRepository.modifyFriend(userID, -1);
    } else {
      await _userRepository.modifyFriendRequest(userID);
    }
    await fetchData(userID);
  }
}
