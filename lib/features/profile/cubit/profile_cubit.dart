import 'package:app_core/app_core.dart';
import 'package:tag_repository/tag_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required UserRepository userRepository,
    required TagRepository tagRepository,
    required String userId,
  })  : _userRepository = userRepository,
        _tagRepository = tagRepository,
        _userID = userId,
        super(ProfileState.loading()) {
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

  late final StreamSubscription<UserData> _userSubscription;

  void _watchUser() {
    _userSubscription =
        _userRepository.watchUserById(uuid: _userID).handleFailure().listen(
              (user) => emit(ProfileState.success(user)),
              onError: (e) => emit(ProfileState.failure()),
            );
  }

  Future<void> _unwatchUser() {
    return _userSubscription.cancel();
  }

  Future<void> updateInterests(List<String> interests) async {
    await _tagRepository.updateUserTags(userId: _userID, tags: interests);

    await _userRepository.updateUser(
      field: UserData.interestsConverter,
      data: interests.join('+'),
    );
  }

  Future<void> editField(String field, dynamic data) async =>
      _userRepository.updateUser(field: field, data: data);
}
