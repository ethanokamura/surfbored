import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:user_repository/src/failures.dart';
import 'package:user_repository/src/models/user.dart';
import 'package:user_repository/src/models/user_profile.dart';

class UserRepository {
  UserRepository({
    SupabaseClient? supabase,
  }) : _supabase = supabase ?? Supabase.instance.client {
    _user = _supabase.authUserChanges(_supabase);
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
  Stream<UserData> watchUserById({required String uuid}) async* {
    try {
      final responseStream = _supabase
          .fromUsersTable()
          .stream(primaryKey: [UserData.idConverter])
          .eq(UserData.uuidConverter, uuid)
          .map((event) {
            if (event.isNotEmpty) {
              return UserData.fromJson(event.first);
            }
            return UserData.empty;
          });

      await for (final userData in responseStream) {
        if (userData == UserData.empty) {
          // Handle case where no data is found, but don't emit failure right away
          yield UserData.empty; // Maybe yield some temporary loading state here
        } else {
          yield userData;
        }
      }
    } catch (e) {
      throw UserFailure.fromStream();
    }
  }
}

extension _SupabaseClientExtensions on SupabaseClient {
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

extension Auth on UserRepository {
  // send OTP
  Future<void> sendOTP({required String phoneNumber}) async {
    try {
      await _supabase.auth.signInWithOtp(phone: phoneNumber);
    } catch (e) {
      throw UserFailure.fromInvalidPhoneNumber();
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
      unawaited(_ensureUserExists(response.user!));
    } catch (e) {
      throw UserFailure.fromPhoneNumberSignIn();
    }
  }

  Future<void> _ensureUserExists(User supabaseUser) async {
    try {
      final res = await _supabase
          .fromUsersTable()
          .select()
          .eq(UserData.uuidConverter, supabaseUser.id)
          .maybeSingle();
      res == null
          ? await _createUser(uuid: supabaseUser.id)
          : await _updateUserData(supabaseUser: supabaseUser);
    } catch (e) {
      throw UserFailure.fromGet();
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

extension Create on UserRepository {
  Future<void> _createUser({required String uuid}) async {
    final data = UserData.insert(uuid: uuid);
    await _supabase.fromUsersTable().insert(data);
  }
}

extension Read on UserRepository {
  // gets the user data by ID
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

extension Update on UserRepository {
  // update user data
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

  Future<void> updateUsername({required String username}) async {
    try {
      return await _supabase
          .fromUsersTable()
          .upsert({UserData.usernameConverter: username}).eq(
        UserData.uuidConverter,
        _supabase.auth.currentUser!.id,
      );
    } catch (e) {
      throw UserFailure.fromUpdate();
    }
  }

  // update specific user profile field
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

extension Delete on UserRepository {}
