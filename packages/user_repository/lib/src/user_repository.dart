import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:user_repository/src/failures.dart';
import 'package:user_repository/src/models/user.dart';
import 'package:user_repository/src/models/user_profile.dart';

/// Repository class for managing user-related operations
class UserRepository {
  /// Constructor for UserRepository.
  /// If [supabase] is not provided, it uses the default Supabase instance.
  UserRepository({SupabaseClient? supabase}) {
    _supabase = supabase ?? Supabase.instance.client;
    _user = _supabase.authUserChanges(_supabase);
  }

  late final SupabaseClient _supabase;
  late final ValueStream<UserData> _user;

  /// Stream of user data changes
  Stream<UserData> get watchUser => _user.asBroadcastStream();

  /// Current user data
  UserData get user => _user.valueOrNull ?? UserData.empty;

  /// Gets the initial user data emission
  Future<UserData> getOpeningUser() => Future.value(user);

  /// Watches user data by UUID
  Stream<UserData> watchUserById({required String uuid}) async* {
    try {
      yield* _supabase
          .fromUsersTable()
          .stream(primaryKey: [UserData.idConverter])
          .eq(UserData.uuidConverter, uuid)
          .map(
            (event) => event.isNotEmpty
                ? UserData.fromJson(event.first)
                : UserData.empty,
          );
    } catch (e) {
      throw UserFailure.fromStream();
    }
  }
}

/// Extension for Supabase client to handle auth changes
extension _SupabaseClientExtensions on SupabaseClient {
  /// Listens to auth state changes and returns a stream of UserData
  ValueStream<UserData> authUserChanges(SupabaseClient supabase) =>
      supabase.auth.onAuthStateChange
          .switchMap<UserData>((auth) async* {
            if (auth.session?.user == null) {
              yield UserData.empty;
              return;
            }
            yield* supabase
                .fromUsersTable()
                .stream(primaryKey: [UserData.idConverter])
                .eq(UserData.uuidConverter, supabase.auth.currentUser!.id)
                .map((event) {
                  if (event.isNotEmpty) {
                    return UserData.fromJson(event.first);
                  }
                  return UserData.empty;
                });
          })
          .handleError((Object _) => throw UserFailure.fromAuthChanges())
          .logOnEach('USER')
          .shareValue();
}

/// Extension for authentication-related operations
extension Auth on UserRepository {
  /// Sends OTP to the provided phone number
  Future<void> sendOTP({required String phoneNumber}) async {
    try {
      await _supabase.auth.signInWithOtp(phone: phoneNumber);
    } catch (e) {
      throw UserFailure.fromInvalidPhoneNumber();
    }
  }

  /// Verifies OTP for the given phone number
  Future<void> verifyOTP({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        type: OtpType.sms,
        phone: phoneNumber,
        token: otp,
      );

      if (response.user == null) {
        throw UserFailure.fromPhoneNumberSignIn();
      }

      /// Ensure the user exists in the database
      unawaited(_ensureUserExists(response.user!));
    } catch (e) {
      throw UserFailure.fromPhoneNumberSignIn();
    }
  }

  /// Ensures that the user exists in the database
  Future<void> _ensureUserExists(User supabaseUser) async {
    try {
      final exists = await _supabase
          .fromUsersTable()
          .select()
          .eq(UserData.uuidConverter, supabaseUser.id)
          .maybeSingle();
      exists == null
          ? await _createUser(uuid: supabaseUser.id)
          : await _updateUserData(supabaseUser: supabaseUser);
    } catch (e) {
      throw UserFailure.fromGet();
    }
  }

  /// Signs out the current user
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw UserFailure.fromSignOut();
    }
  }
}

/// Extension for username-related operations
extension Username on UserRepository {
  /// Checks if the given username is unique
  Future<bool> isUsernameUnique({required String username}) async {
    try {
      final res = await _supabase
          .fromUsersTable()
          .select()
          .eq(UserData.usernameConverter, username)
          .maybeSingle();
      return res == null;
    } catch (e) {
      throw UserFailure.fromGet();
    }
  }
}

/// Extension for user creation operations
extension Create on UserRepository {
  /// Creates a new user with the given UUID
  Future<void> _createUser({required String uuid}) async {
    try {
      final data = UserData.insert(uuid: uuid);
      await _supabase.fromUsersTable().insert(data);
    } catch (e) {
      throw UserFailure.fromCreate();
    }
  }
}

/// Extension for read operations
extension Read on UserRepository {
  /// Reads user data by UUID
  Future<UserData> readUserData({required String uuid}) async {
    try {
      return await _supabase
          .fromUsersTable()
          .select()
          .eq(UserData.uuidConverter, uuid)
          .maybeSingle()
          .withConverter(
            (data) =>
                data == null ? UserData.empty : UserData.converterSingle(data),
          );
    } catch (e) {
      throw UserFailure.fromGet();
    }
  }

  /// Searches for users based on a query
  Future<List<UserProfile>> searchUsers({
    required String query,
    required int offset,
    required int limit,
  }) async {
    try {
      return await _supabase
          .fromUsersTable()
          .select('username, photo_url')
          .textSearch(UserData.userSearchQuery, query)
          .range(offset, offset + limit - 1)
          .withConverter(UserProfile.converter);
    } catch (e) {
      throw UserFailure.fromGet();
    }
  }

  /// Reads user profile by UUID
  Future<UserProfile> readUserProfile({required String uuid}) async {
    try {
      return await _supabase
          .fromUsersTable()
          .select('username, photo_url')
          .eq(UserData.uuidConverter, uuid)
          .maybeSingle()
          .withConverter(
            (data) => data == null
                ? UserProfile.empty
                : UserProfile.converterSingle(data),
          );
    } catch (e) {
      throw UserFailure.fromGet();
    }
  }
}

/// Extension for update operations
extension Update on UserRepository {
  /// Updates user data
  Future<void> _updateUserData({required User? supabaseUser}) async {
    try {
      if (supabaseUser == null) return;
      await _supabase.fromUsersTable().upsert({
        UserData.uuidConverter: supabaseUser.id,
        UserData.lastSignInConverter: DateTime.now().toUtc().toIso8601String(),
      }).eq(UserData.uuidConverter, supabaseUser.id);
    } catch (e) {
      throw UserFailure.fromUpdate();
    }
  }

  /// Updates the username for the current user
  Future<void> updateUsername({required String username}) async {
    try {
      // TODO(Ethan): check here for validity of the username
      return await _supabase
          .fromUsersTable()
          .update({UserData.usernameConverter: username}).eq(
        UserData.uuidConverter,
        _supabase.auth.currentUser!.id,
      );
    } catch (e) {
      throw UserFailure.fromUpdate();
    }
  }

  /// Updates a specific field of the user profile
  Future<void> updateUser({
    required String field,
    required dynamic data,
  }) async {
    try {
      if (user.id == null) return;
      await _supabase
          .fromUsersTable()
          .update({field: data}).eq(UserData.idConverter, user.id!);
    } catch (e) {
      throw UserFailure.fromUpdate();
    }
  }
}

/// Extension for delete operations (currently empty)
extension Delete on UserRepository {}
