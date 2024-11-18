import 'package:app_core/app_core.dart';
import 'package:user_repository/user_repository.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  /// Constructs AppCubit
  /// Takes in UserRepository instance and sets the initial AppState.
  AppCubit({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(_initialState(userRepository.user)) {
    _watchUser();
  }

  final UserRepository _userRepository;

  /// Sets initial auth state for the app
  /// Checks to see the current status of user authetication
  static AppState _initialState(UserData user) {
    if (user.isEmpty) {
      return const AppState.unauthenticated();
    }
    return user.hasUsername
        ? AppState.newlyAuthenticated(user)
        : const AppState.needsUsername();
  }

  void verifyUsernameExistence() {
    final user = _userRepository.user;
    user.hasUsername
        ? emit(AppState.newlyAuthenticated(user))
        : emit(const AppState.needsUsername());
  }

  void usernameSubmitted() =>
      emit(AppState.newlyAuthenticated(_userRepository.user));

  @override
  Future<void> close() async {
    await _unwatchUser();
    return super.close();
  }

  /// Logs out current user.
  Future<void> logOut() async {
    try {
      await _userRepository.signOut();
    } on UserFailure catch (failure) {
      _onUserFailed(failure);
    }
  }

  /// Listens to auth changes and updates state accordingly
  void _onUserChanged(UserData user) {
    if (user.isEmpty) {
      emit(const AppState.unauthenticated());
    } else {
      if (state.isUnauthenticated) {
        emit(
          user.hasUsername
              ? AppState.newlyAuthenticated(user)
              : const AppState.needsUsername(),
        );
      } else {
        emit(AppState.authenticated(user));
      }
    }
  }

  /// Listens to auth failures and updates state accordingly
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

  /// Listens to auth changes
  void _watchUser() {
    _userSubscription = _userRepository.watchUser
        .handleFailure(_onUserFailed)
        .listen(_onUserChanged);
  }

  Future<void> _unwatchUser() {
    return _userSubscription.cancel();
  }
}
