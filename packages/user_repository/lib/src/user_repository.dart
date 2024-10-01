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

  /// Current user as a stream.
  Stream<UserData> get watchUser => _user.asBroadcastStream();

  /// Get the current user's data synchronously.
  UserData get user => _user.valueOrNull ?? UserData.empty;

  /// Gets the initial [watchUser] emission.
  Future<UserData> getOpeningUser() {
    return watchUser.first.catchError((Object _) => UserData.empty);
  }

  /// Gets a generic [watchUser] emission.
  Stream<UserData> watchUserByID({
    required int uuid,
  }) {
    return _supabase
        .fromUsersTable()
        .stream(primaryKey: [UserData.idConverter])
        .eq(UserData.idConverter, uuid)
        .map((event) {
          if (event.isNotEmpty) {
            return UserData.fromJson(event.first);
          }
          return UserData.empty; // Fallback for no user found
        });
  }

  /// Watch for auth state changes and emit user data.
  ValueStream<UserData> authUserChanges() {
    final controller = BehaviorSubject<UserData>();

    _supabase.auth.onAuthStateChange.listen((event) async {
      final session = event.session;

      // logged out
      if (session?.user == null) {
        controller.add(UserData.empty);
        return;
      }

      await _ensureUserExists(user: session!.user);

      // get user
      final response = await _supabase
          .fromUsersTable()
          .select()
          .eq(UserData.idConverter, session.user.id)
          .single()
          .withConverter(UserData.converterSingle);

      // Yield the user data
      controller.add(response);
    }).onError((error) {
      controller.addError(UserFailure.fromAuthUserChanges());
    });

    return controller.stream.logOnEach('USER').shareValue();
  }
}

extension Auth on UserRepository {
  // send OTP
  Future<void> sendOTP({
    required String phoneNumber,
  }) async {
    await _supabase.auth.signInWithOtp(phone: phoneNumber);
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

      if (response.user != null) {
        await _ensureUserExists(user: response.user!);
      } else {
        throw UserFailure.fromPhoneNumberSignIn();
      }
      await _updateUserData(supabaseUser: response.user);
    } on AuthException {
      throw UserFailure.fromPhoneNumberSignIn();
    }
  }

  // Ensure user exists in the database
  Future<void> _ensureUserExists({
    required User user,
  }) async {
    // Check if the user exists in the 'users' table
    final existingUser = await _supabase
        .fromUsersTable()
        .select()
        .eq(UserData.idConverter, user.id)
        .maybeSingle();

    // If user does not exist, insert them
    if (existingUser == null) {
      final userData = UserData.insert();
      await submitPhoneNumber(phoneNumber: _supabase.auth.currentUser!.phone!);
      await _supabase.fromUsersTable().insert(userData);
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
  Future<bool> userHasUsername() async {
    if (user.id == null) return false;
    final res = await _supabase
        .fromUsersTable()
        .select(UserData.usernameConverter)
        .eq(UserData.idConverter, user.id!)
        .maybeSingle();
    return res != null;
  }

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
        await _supabase
            .fromUsersTable()
            .insert({UserData.usernameConverter: username});
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
        .eq(UserData.idConverter, _supabase.auth.currentUser!.id)
        .select()
        .single()
        .withConverter(UserData.converterSingle);
    return res;
  }
}

extension Read on UserRepository {
  // gets the user data by ID
  Future<UserData> readUserData({
    required int uuid,
  }) async {
    final res = await _supabase
        .fromUsersTable()
        .select()
        .eq(UserData.idConverter, uuid)
        .maybeSingle()
        .withConverter(
          (data) =>
              data == null ? UserData.empty : UserData.converterSingle(data),
        );
    return res;
  }

  Future<UserProfile> readUserProfile({
    required int uuid,
  }) async {
    final res = await _supabase
        .fromUsersTable()
        .select('username, photo_url')
        .eq(UserData.idConverter, uuid)
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
        UserData.lastSignInConverter: DateTime.now().toUtc(),
      }).eq(UserData.idConverter, supabaseUser.id);
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
