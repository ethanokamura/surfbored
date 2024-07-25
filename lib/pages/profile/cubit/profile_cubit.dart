import 'package:app_core/app_core.dart';
import 'package:user_repository/user_repository.dart';

class ProfileCubit extends Cubit<User> {
  ProfileCubit({
    required UserRepository userRepository,
    required String userID,
  })  : _userRepository = userRepository,
        _userID = userID,
        super(User.empty) {
    _watchUser();
  }

  final UserRepository _userRepository;
  final String _userID;

  @override
  Future<void> close() async {
    await _unwatchUser();
    return super.close();
  }

  bool isCurrent() {
    return _userRepository.isCurrentUser(_userID);
  }

  Future<void> editField(String field, String data) async {
    await _userRepository.updateField(_userID, field, data);
  }

  Future<void> logOut() async {
    await _userRepository.signOut();
  }

  void _onUserChanged(User user) => emit(user);

  late final StreamSubscription<User> _userSubscription;

  void _watchUser() {
    _userSubscription = _userRepository
        .watchUserByID(_userID)
        // user/auth failures are handled by the AppCubit
        .handleFailure()
        .listen(_onUserChanged);
  }

  Future<void> _unwatchUser() {
    return _userSubscription.cancel();
  }
}
