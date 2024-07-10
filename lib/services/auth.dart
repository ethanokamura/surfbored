// dart packages
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';

// utils
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:rando/services/firestore.dart';
import 'package:rando/utils/global.dart';
import 'package:logger/logger.dart';

// pages
import 'package:rando/pages/lists.dart';
import 'package:rando/pages/profile/create_profile.dart';

// implementing firebase auth
class AuthService {
  final logger = Logger();
  // stream of current user's data (async)
  // used when we want to detect auth state change but timing is unknown
  final userStream = FirebaseAuth.instance.authStateChanges();

  // event in which we need the current auth state (sync)
  // gives user a way to create records
  final user = FirebaseAuth.instance.currentUser;

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
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (context.mounted) await routeUser();
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
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // sign in
      await FirebaseAuth.instance.signInWithCredential(authCredential);
      await routeUser();
    } on FirebaseAuthException catch (e) {
      // handle error
      print("error: $e");
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    await routeUser();
    return userCredential;
  }

  // Route user based on username existence
  Future<void> routeUser() async {
    final bool hasUsername = await FirestoreService().userHasUsername();
    final user = AuthService().user;
    if (user != null) {
      if (hasUsername) {
        print("user has username!");
        navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(builder: (context) => ListScreen(userID: user.uid)),
        );
      } else {
        print("user does not have username!");
        navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(builder: (context) => const CreateProfilePage()),
        );
      }
    } else {
      // handle case where user is null (possibly show a login screen)
      print("user is null");
    }
  }
}
