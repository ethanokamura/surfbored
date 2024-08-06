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
              : AppState.newlyAuthenticated(userRepository.user),
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

  Future<void> _onUserChanged(User user) async {
    if (user.isEmpty) {
      emit(const AppState.unauthenticated());
    } else {
      await checkUserRegistration(user);
    }
  }

  Future<void> checkUserRegistration(User user) async {
    final hasUsername = await _userRepository.userHasUsername(user.uid);
    if (hasUsername) {
      emit(AppState.authenticated(user));
    } else {
      emit(AppState.needsRegistration(user));
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

  void updateStatus(AppStatus status, {Map<String, dynamic>? parameters}) {
    emit(state.copyWith(status: status, parameters: parameters));
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
