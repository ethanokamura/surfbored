import 'package:app_core/app_core.dart';
import 'package:user_repository/user_repository.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(
          userRepository.user.isEmpty
              ? const AppState.unauthenticated()
              : userRepository.user.hasUsername
                  ? AppState.newlyAuthenticated(userRepository.user)
                  : AppState.newlyAuthenticatedWithoutUsername(
                      userRepository.user,
                    ),
        ) {
    _watchUser();
  }

  final UserRepository _userRepository;

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

  void confirmedUsername(User user) {
    print('confirming username');
    emit(AppState.newlyAuthenticated(user));
  }

  void _onUserChanged(User user) {
    if (user.isEmpty) {
      emit(const AppState.unauthenticated());
    } else if (state.isUnauthenticated) {
      if (user.hasUsername) {
        print('user has username. emitting newly auth');
        emit(AppState.newlyAuthenticated(user));
      } else {
        print('user has no username. emitting without username');
        emit(AppState.newlyAuthenticatedWithoutUsername(user));
      }
    } else {
      emit(AppState.authenticated(user));
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

  late final StreamSubscription<User> _userSubscription;
  void _watchUser() {
    _userSubscription = _userRepository.watchUser
        .handleFailure(_onUserFailed)
        .listen(_onUserChanged);
  }

  Future<void> _unwatchUser() {
    return _userSubscription.cancel();
  }
}
