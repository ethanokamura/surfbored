import 'package:app_core/app_core.dart';
import 'package:user_repository/user_repository.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(_initialState(userRepository.user)) {
    _watchUser();
  }

  final UserRepository _userRepository;

  static AppState _initialState(UserData user) {
    if (user.isEmpty) {
      return const AppState.unauthenticated();
    }
    return user.hasUsername
        ? AppState.newlyAuthenticated(user)
        : AppState.needsUsername(user);
  }

  void reinitState() {
    final user = _userRepository.user;
    if (user.isEmpty) {
      emit(const AppState.unauthenticated());
    }
    user.hasUsername
        ? emit(AppState.newlyAuthenticated(user))
        : emit(AppState.needsUsername(user));
  }

  @override
  Future<void> close() async {
    await _unwatchUser();
    return super.close();
  }

  Future<void> logOut() async {
    try {
      await _userRepository.signOut();
    } on UserFailure catch (failure) {
      _onUserFailed(failure);
    }
  }

  void _onUserChanged(UserData user) {
    if (user.isEmpty) {
      emit(const AppState.unauthenticated());
    } else {
      if (state.isUnauthenticated) {
        emit(
          user.hasUsername
              ? AppState.newlyAuthenticated(user)
              : AppState.needsUsername(user),
        );
      } else {
        emit(AppState.authenticated(user));
      }
    }
  }

  void _onUserFailed(UserFailure failure) {
    final currentState = state;
    emit(AppState.failure(failure: failure, user: currentState.user));
    if (failure.needsReauthentication) {
      emit(const AppState.unauthenticated());
    } else {
      emit(currentState);
    }
  }

  late final StreamSubscription<UserData> _userSubscription;

  void _watchUser() {
    _userSubscription = _userRepository.watchUser
        .handleFailure(_onUserFailed)
        .listen(_onUserChanged);
  }

  Future<void> _unwatchUser() {
    return _userSubscription.cancel();
  }
}
