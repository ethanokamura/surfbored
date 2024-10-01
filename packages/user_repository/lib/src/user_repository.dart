import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:user_repository/src/failures.dart';
import 'package:user_repository/src/models/profile.dart';
import 'package:user_repository/src/models/user.dart';

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
  Stream<UserData> watchUserByID(String uuid) {
    return _supabase
        .from('users')
        .stream(primaryKey: ['id'])
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

      await _ensureUserExists(session!.user);

      // get user
      final response = await _supabase
          .from('users')
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
  Future<void> sendOTP({required String phoneNumber}) async {
    await _supabase.auth.signInWithOtp(phone: phoneNumber);
  }

  // verify OTP
  Future<void> verifyOTP(String phoneNumber, String otp) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        type: OtpType.sms,
        phone: phoneNumber,
        token: otp,
      );

      if (response.user != null) {
        await _ensureUserExists(response.user!);
      } else {
        throw UserFailure.fromPhoneNumberSignIn();
      }
      await _updateUserData(response.user);
    } on AuthException {
      throw UserFailure.fromPhoneNumberSignIn();
    }
  }

  // Ensure user exists in the database
  Future<void> _ensureUserExists(User user) async {
    // Check if the user exists in the 'users' table
    final existingUser = await _supabase
        .from('users')
        .select()
        .eq(UserData.idConverter, user.id)
        .maybeSingle();

    // If user does not exist, insert them
    if (existingUser == null) {
      final userData = UserData.insert(id: _supabase.auth.currentUser!.id);
      final profileData = ProfileData.insert(
        userId: _supabase.auth.currentUser!.id,
        phoneNumber: user.phone,
      );
      await _supabase.from('users').insert(userData);
      await _supabase.from('user_profiles').insert(profileData);
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
  Future<bool> isUsernameUnique(String username) async {
    final res = await _supabase
        .from('users')
        .select()
        .eq(UserData.usernameConverter, username)
        .maybeSingle();
    return res == null;
  }

  Future<void> updateUsername(String username) async {
    try {
      await _supabase
          .from('users')
          .update({UserData.usernameConverter: username}).eq(
        UserData.idConverter,
        user.id,
      );
    } catch (e) {
      throw UserFailure.fromUpdateUser();
    }
  }
}

extension Create on UserRepository {
  Future<UserData> createUser(String username) async {
    final res = await _supabase
        .from('users')
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
  Future<UserData> readUserData(String uuid) async {
    final res = await _supabase
        .from('users')
        .select()
        .eq(UserData.idConverter, uuid)
        .maybeSingle()
        .withConverter(
          (data) =>
              data == null ? UserData.empty : UserData.converterSingle(data),
        );
    return res;
  }

  // gets the user data by ID
  Future<ProfileData> readUserProfile(String uuid) async {
    final res = await _supabase
        .from('user_profiles')
        .select()
        .eq(ProfileData.userIdConverter, uuid)
        .maybeSingle()
        .withConverter(
          (data) => data == null
              ? ProfileData.empty
              : ProfileData.converterSingle(data),
        );
    return res;
  }
}

extension Update on UserRepository {
  // update user data
  Future<void> _updateUserData(User? supabaseUser) async {
    try {
      if (supabaseUser == null) return;
      await _supabase.from('user_profiles').upsert({
        ProfileData.lastSignInConverter: DateTime.now().toUtc(),
      }).eq(ProfileData.userIdConverter, supabaseUser.id);
    } catch (e) {
      throw UserFailure.fromUpdateUser();
    }
  }

  // update specific user profile field
  Future<void> updateUserProfile(
    String field,
    dynamic data,
  ) async {
    try {
      await _supabase
          .from('user_profiles')
          .update({field: data}).eq(ProfileData.userIdConverter, user.id);
    } catch (e) {
      throw UserFailure.fromUpdateUser();
    }
  }

  Future<void> updateUsername(String url) async {
    try {
      await _supabase.from('users').update({
        UserData.photoUrlConverter: url,
      }).eq(UserData.idConverter, user.id);
    } catch (e) {
      throw UserFailure.fromUpdateUser();
    }
  }
}

extension Delete on UserRepository {}
