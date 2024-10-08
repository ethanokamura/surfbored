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
    try {
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
    } catch (e) {
      throw UserFailure.fromStream();
    }
  }

  ValueStream<UserData> authUserChanges() => _supabase.auth.onAuthStateChange
      .switchMap<UserData>((auth) async* {
        if (auth.session?.user == null) {
          yield UserData.empty;
        } else {
          try {
            final userData = await readUserData(uuid: auth.session!.user.id);
            yield userData;
          } catch (e) {
            yield UserData.empty; // Handle error and emit empty user
          }
        }
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
      await _ensureUserExists(response.user!);
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
      print(e);
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
