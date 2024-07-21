// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rando/utils/data/firestore/user_service.dart';
import 'package:rando/utils/global.dart';
import 'package:logger/logger.dart';

// pages
import 'package:rando/pages/home.dart';
import 'package:rando/pages/profile/create_profile.dart';

// implementing firebase auth
class AuthService {
  // firestore authentication reference
  static final FirebaseAuth auth = FirebaseAuth.instance;

  // stream of current user's data (async)
  // used when we want to detect auth state change but timing is unknown
  final Stream<User?> userStream = auth.authStateChanges();

  // event in which we need the current auth state (sync)
  // gives user a way to create records
  final User? user = auth.currentUser;

  // helps log messages
  static final Logger _logger = Logger();

  // sign in with phone
  Future<void> verifyPhone({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) verificationCompleted,
    required void Function(FirebaseAuthException) verificationFailed,
    required void Function(String, int?) codeSent,
    required void Function(String) codeAutoRetrievalTimeout,
  }) async {
    try {
      _logger.i("user entered number $phoneNumber waiting on verification");
      await auth.verifyPhoneNumber(
        phoneNumber: "+1$phoneNumber",
        timeout: const Duration(seconds: 30),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
      _logger.i("$phoneNumber verified");
    } catch (e) {
      // catch error
      _logger.e("Error verifying phone number $e");
    }
  }

  // sign in with OTP
  Future<void> signInWithOTP(String otp, String? verificationId) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: otp,
    );
    try {
      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      await routeUser();
      _logger.i("Successfully signed in UID: ${userCredential.user?.uid}");
    } on FirebaseAuthException catch (e) {
      _logger.e(e.message.toString());
    } catch (e) {
      _logger.e(e.toString());
    }
  }

  // sign out
  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // check auth
  static Future<bool> isSignedIn() async {
    var user = AuthService().user;
    return user != null;
  }

  // Route user based on username existence
  Future<void> routeUser() async {
    final bool hasUsername = await UserService().userHasUsername();
    if (user != null) {
      if (hasUsername) {
        navigatorKey.currentState!.pushReplacement<dynamic, Object?>(
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const HomeScreen(),
          ),
        );
      } else {
        navigatorKey.currentState!.pushReplacement<dynamic, Object?>(
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const CreateProfilePage(),
          ),
        );
      }
    } else {
      // handle case where user is null (possibly show a login screen)
      _logger.e("user is null");
    }
  }
}

/*

import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

  // anonymous firebase login
  Future<void> anonLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      // handle error
      throw Exception("error with annonymous login: $e");
    }
  }

  // anonymous firebase login
  Future<void> emailLogin(
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await routeUser();
    } on FirebaseAuthException catch (e) {
      // handle error
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else {
        errorMessage = 'Error: ${e.message}';
      }
      _logger.e(errorMessage);
    }
  }


  // google firebase login
  Future<void> googleLogin() async {
    try {
      // have user log in to google account
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // no user found
      if (googleUser == null) return;
      // await google auth
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // create user credentials
      final OAuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // sign in
      await FirebaseAuth.instance.signInWithCredential(authCredential);
      await routeUser();
    } on FirebaseAuthException catch (e) {
      // handle error
      _logger.e("error: $e");
    }
  }

  String generateNonce([int length = 32]) {
    const String charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final Random random = Random.secure();
    return List<String>.generate(
        length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final Uint8List bytes = utf8.encode(input);
    final Digest digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final String rawNonce = generateNonce();
    final String nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final AuthorizationCredentialAppleID appleCredential =
        await SignInWithApple.getAppleIDCredential(
      scopes: <AppleIDAuthorizationScopes>[
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final OAuthCredential oauthCredential =
        OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    await routeUser();

    return userCredential;
  }

*/