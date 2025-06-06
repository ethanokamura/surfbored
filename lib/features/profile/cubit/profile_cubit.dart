import 'package:app_core/app_core.dart';
import 'package:tag_repository/tag_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'profile_state.dart';

/// Manages the state and logic for user-related operations.
class ProfileCubit extends Cubit<ProfileState> {
  /// Creates a new instance of [ProfileCubit].
  /// Requires a [UserRepository] and [TagRepository] to handle data operations.
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

  /// Stops listening to the current user
  @override
  Future<void> close() async {
    await _unwatchUser();
    return super.close();
  }

  late final StreamSubscription<UserData> _userSubscription;

  /// Listens to the current user by their ID
  void _watchUser() {
    _userSubscription =
        _userRepository.watchUserById(uuid: _userID).handleFailure().listen(
              (user) => emit(ProfileState.success(user)),
              onError: (e) => emit(ProfileState.failure()),
            );
  }

  /// Private helper funciton to cancel the user subscription
  Future<void> _unwatchUser() {
    return _userSubscription.cancel();
  }

  /// Updates user [interests] for the given user
  Future<void> updateInterests(List<String> interests) async {
    await _tagRepository.updateUserTags(userId: _userID, tags: interests);

    await _userRepository.updateUserField(
      field: UserData.interestsConverter,
      data: interests.join('+'),
    );
  }

  /// Updates the given [field] with [data] for the current user
  Future<void> editField(String field, dynamic data) async =>
      _userRepository.updateUserField(field: field, data: data);

  Future<void> saveChanges(Map<String, dynamic> data) async =>
      _userRepository.updateUser(data: data, uuid: _userID);
}
