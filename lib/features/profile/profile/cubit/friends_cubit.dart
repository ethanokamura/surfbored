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
      final sender = await _userRepository.fetchRequestSender(userID);

      if (areFriends) {
        emit(state.fromFriendSuccess(areFriends: areFriends));
      } else if (sender != null) {
        emit(state.fromRequestLoaded(senderID: sender));
      }
      emit(state.fromFriendsLoaded(friends: friends));
    } catch (e) {
      emit(state.fromFailure());
    }
  }

  Future<void> toggleFriendRequest(String userID) async {
    emit(state.fromLoading());
    try {
      await _userRepository.toggleFriendRequest(userID);
      final sender = await _userRepository.fetchRequestSender(userID);
      emit(state.fromRequestLoaded(senderID: sender));
    } catch (e) {
      emit(state.fromFailure());
    }
  }

  Future<void> toggleFriend(String userID) async {
    emit(state.fromLoading());
    try {
      final areFriends = await _userRepository.toggleFriend(userID);
      final friends = await _userRepository.fetchFriendCount(userID);
      emit(state.fromFriendSuccess(areFriends: areFriends));
      emit(state.fromFriendsLoaded(friends: friends));
    } catch (e) {
      emit(state.fromFailure());
    }
  }
}
