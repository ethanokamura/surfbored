import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:user_repository/src/failures.dart';
import 'package:user_repository/src/models/user.dart';
import 'package:user_repository/src/models/user_profile.dart';

class UserRepository {
  UserRepository({
    SupabaseClient? supabase,
  }) : _supabase = supabase ?? Supabase.instance.client {
    _user = authUserChanges();
  }

  final SupabaseClient _supabase;
  late final ValueStream<UserData> _user;

  // current user as a stream
  Stream<UserData> get watchUser => _user.asBroadcastStream();

  // get the current user's data synch
  UserData get user => _user.valueOrNull ?? UserData.empty;

  /// Gets the initial [watchUser] emission.
  /// Returns [UserData.empty] when an error occurs.
  Future<UserData> getOpeningUser() {
    return watchUser.first.catchError((Object _) => UserData.empty);
  }

  /// Gets a generic [watchUser] emission.
  Stream<UserData> watchUserByID({required String id}) {
    return _supabase
        .fromUsersTable()
        .stream(primaryKey: [UserData.uuidConverter])
        .eq(UserData.uuidConverter, id)
        .map((event) {
          if (event.isNotEmpty) {
            return UserData.fromJson(event.first);
          }
          return UserData.empty; // Fallback for no user found
        });
  }

  ValueStream<UserData> authUserChanges() {
    return _supabase.auth.onAuthStateChange
        .switchMap<UserData>((auth) async* {
          if (auth.session?.user == null) {
            yield UserData.empty;
          } else {
            try {
              final userData =
                  await readUserDataWithUUID(uuid: auth.session!.user.id);
              yield userData;
            } catch (e) {
              yield UserData.empty; // Handle error and emit empty user
            }
          }
        })
        .handleError((Object _) => throw UserFailure.fromAuthUserChanges())
        .logOnEach('USER')
        .shareValue();
  }
}

extension Auth on UserRepository {
  // send OTP
  Future<void> sendOTP({
    required String phoneNumber,
  }) async {
    try {
      await _supabase.auth.signInWithOtp(phone: phoneNumber);
    } catch (e) {
      throw Exception('failure to send otp: $e');
    }
  }

  // verify OTP
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
      await _updateUserData(supabaseUser: response.user);
    } catch (e) {
      throw UserFailure.fromPhoneNumberSignIn();
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw UserFailure.fromSignOut();
    }
  }
}

extension Username on UserRepository {
  // Check if username is unique
  Future<bool> isUsernameUnique({
    required String username,
  }) async {
    final res = await _supabase
        .fromUsersTable()
        .select()
        .eq(UserData.usernameConverter, username)
        .maybeSingle();
    return res == null;
  }

  Future<void> updateUsername({
    required String username,
  }) async {
    try {
      if (user.id != null) {
        await _supabase
            .fromUsersTable()
            .update({UserData.usernameConverter: username}).eq(
          UserData.idConverter,
          user.id!,
        );
      } else {
        final data = UserData.insert(
          username: username,
          uuid: _supabase.auth.currentUser!.id,
        );
        await _supabase.fromUsersTable().insert(data);
      }
    } catch (e) {
      throw UserFailure.fromUpdateUser();
    }
  }
}

extension Create on UserRepository {
  Future<UserData> createUser({
    required String username,
  }) async {
    final res = await _supabase
        .fromUsersTable()
        .update({UserData.usernameConverter: username})
        .eq(UserData.uuidConverter, _supabase.auth.currentUser!.id)
        .select()
        .single()
        .withConverter(UserData.converterSingle);
    return res;
  }
}

extension Read on UserRepository {
  // gets the user data by ID
  Future<UserData> readUserData({
    required int id,
  }) async {
    final res = await _supabase
        .fromUsersTable()
        .select()
        .eq(UserData.idConverter, id)
        .maybeSingle()
        .withConverter(
          (data) =>
              data == null ? UserData.empty : UserData.converterSingle(data),
        );
    return res;
  }

  // gets the user data by ID
  Future<UserData> readUserDataWithUUID({
    required String uuid,
  }) async {
    final res = await _supabase
        .fromUsersTable()
        .select()
        .eq(UserData.uuidConverter, uuid)
        .maybeSingle()
        .withConverter(
          (data) =>
              data == null ? UserData.empty : UserData.converterSingle(data),
        );
    return res;
  }

  Future<List<UserProfile>> searchUsers({
    required String query,
    required int offset,
    required int limit,
  }) async =>
      _supabase
          .fromUsersTable()
          .select('username, photo_url')
          .textSearch(UserData.userSearchQuery, query)
          .range(offset, offset + limit - 1)
          .withConverter(UserProfile.converter);

  Future<UserProfile> readUserProfile({
    required String uuid,
  }) async {
    final res = await _supabase
        .fromUsersTable()
        .select('username, photo_url')
        .eq(UserData.uuidConverter, uuid)
        .maybeSingle()
        .withConverter(
          (data) => data == null
              ? UserProfile.empty
              : UserProfile.converterSingle(data),
        );
    return res;
  }
}

extension Update on UserRepository {
  // update user data
  Future<void> _updateUserData({
    required User? supabaseUser,
  }) async {
    try {
      if (supabaseUser == null) return;
      await _supabase.fromUsersTable().upsert({
        UserData.uuidConverter: supabaseUser.id,
        UserData.lastSignInConverter: DateTime.now().toUtc().toIso8601String(),
      }).eq(UserData.uuidConverter, supabaseUser.id);
    } catch (e) {
      throw UserFailure.fromUpdateUser();
    }
  }

  // update specific user profile field
  Future<void> updateUser({
    required String field,
    required dynamic data,
  }) async {
    try {
      if (user.id != null) {
        await _supabase
            .fromUsersTable()
            .update({field: data}).eq(UserData.idConverter, user.id!);
      } else {
        throw UserFailure.fromUpdateUser();
      }
    } catch (e) {
      throw UserFailure.fromUpdateUser();
    }
  }
}

extension Delete on UserRepository {}
