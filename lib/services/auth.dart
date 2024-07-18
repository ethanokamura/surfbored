// dart packages
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';

// utils
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rando/services/firestore/user_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:rando/utils/global.dart';
import 'package:logger/logger.dart';

// pages
import 'package:rando/pages/home.dart';
import 'package:rando/pages/profile/create_profile.dart';

// implementing firebase auth
class AuthService {
  final Logger logger = Logger();

  // stream of current user's data (async)
  // used when we want to detect auth state change but timing is unknown
  final Stream<User?> userStream = FirebaseAuth.instance.authStateChanges();

  // event in which we need the current auth state (sync)
  // gives user a way to create records
  final User? user = FirebaseAuth.instance.currentUser;

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
      logger.e(errorMessage);
    }
  }

  // sign out
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
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
      logger.e("error: $e");
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

  // Route user based on username existence
  Future<void> routeUser() async {
    final bool hasUsername = await UserService().userHasUsername();
    final User? user = AuthService().user;
    if (user != null) {
      if (hasUsername) {
        navigatorKey.currentState!.pushReplacement<dynamic, Object?>(
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const HomeScreen()),
        );
      } else {
        navigatorKey.currentState!.pushReplacement<dynamic, Object?>(
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const CreateProfilePage()),
        );
      }
    } else {
      // handle case where user is null (possibly show a login screen)
      logger.e("user is null");
    }
  }
}
