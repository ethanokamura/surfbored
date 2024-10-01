import 'package:app_core/app_core.dart';
import 'package:tag_repository/tag_repository.dart';
import 'package:user_repository/user_repository.dart';

class ProfileCubit extends Cubit<UserData> {
  ProfileCubit({
    required UserRepository userRepository,
    required TagRepository tagRepository,
    required String userID,
  })  : _userRepository = userRepository,
        _tagRepository = tagRepository,
        _userID = userID,
        super(UserData.empty) {
    _watchUser();
  }

  final UserRepository _userRepository;
  final TagRepository _tagRepository;
  final String _userID;

  @override
  Future<void> close() async {
    await _unwatchUser();
    return super.close();
  }

  void _onUserChanged(UserData user) => emit(user);

  late final StreamSubscription<UserData> _userSubscription;
  void _watchUser() {
    _userSubscription = _userRepository
        .watchUserByID(uuid: _userID)
        .handleFailure()
        .listen(_onUserChanged);
  }

  Future<void> _unwatchUser() {
    return _userSubscription.cancel();
  }

  Future<List<String>> fetchUserTags(String userId) =>
      _tagRepository.readUserTags(uuid: userId);

  Future<void> editField(String field, dynamic data) async =>
      _userRepository.updateUserProfile(field: field, data: data);
}
