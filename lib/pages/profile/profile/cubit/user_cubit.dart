import 'package:app_core/app_core.dart';
import 'package:user_repository/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const UserState.initial());

  final UserRepository _userRepository;

  void streamItems(String userID) {
    emit(state.fromUserLoading());
    try {
      _userRepository.getUserItemStream(userID).listen(
        (snapshot) {
          emit(state.fromListLoaded(snapshot));
        },
        onError: (dynamic error) {
          emit(state.fromUserEmpty());
        },
      );
    } on UserFailure catch (failure) {
      emit(state.fromUserFailure(failure));
    }
  }

  void streamBoards(String userID) {
    emit(state.fromUserLoading());
    try {
      _userRepository.getUserBoardStream(userID).listen(
        (snapshot) {
          emit(state.fromListLoaded(snapshot));
        },
        onError: (dynamic error) {
          emit(state.fromUserEmpty());
        },
      );
    } on UserFailure catch (failure) {
      emit(state.fromUserFailure(failure));
    }
  }
}

extension _UserStateExtensions on UserState {
  UserState fromUserLoading() => copyWith(status: UserStatus.loading);

  UserState fromUserEmpty() => copyWith(status: UserStatus.empty);

  UserState fromListLoaded(List<String> items) => copyWith(
        status: UserStatus.loaded,
        items: items,
      );
  UserState fromUserFailure(UserFailure failure) => copyWith(
        status: UserStatus.failure,
        failure: failure,
      );
}
