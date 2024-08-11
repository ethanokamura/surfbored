import 'package:api_client/api_client.dart' as firebase show User;
import 'package:api_client/api_client.dart' hide User;
import 'package:app_core/app_core.dart';
import 'package:user_repository/src/failures.dart';
import 'package:user_repository/src/models/models.dart';

class UserRepository {
  UserRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance {
    _user = _firebaseAuth.authUserChanges(_firestore);
  }

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final Map<String, String> _usernameCache = {};

  late final ValueStream<User> _user;

  // current user as a stream
  Stream<User> get watchUser => _user.asBroadcastStream();

  // get the current user's data synchonously
  User get user => _user.valueOrNull ?? User.empty;

  /// Gets the initial [watchUser] emission.
  ///
  /// Returns [User.empty] when an error occurs.
  Future<User> getOpeningUser() {
    return watchUser.first.catchError((Object _) => User.empty);
  }

  // get the current user
  User fetchCurrentUser() {
    return user;
  }

  // get current user's ID
  String fetchCurrentUserID() {
    return _firebaseAuth.currentUser!.uid;
  }

  // check if the current user is the provided user
  bool isCurrentUser(String userID) {
    return _firebaseAuth.currentUser!.uid == userID;
  }

  /// gets generic [watchUser] emmision
  Stream<User> watchUserByID(String userID) {
    return _firestore.userDoc(userID).snapshots().map(
      (snapshot) {
        return snapshot.exists ? User.fromJson(snapshot.data()!) : User.empty;
      },
    );
  }
}

extension _FirebaseAuthExtensions on FirebaseAuth {
  ValueStream<User> authUserChanges(FirebaseFirestore firestore) =>
      authStateChanges()
          .onErrorResumeWith((_, __) => null)
          .switchMap<User>(
            (firebaseUser) async* {
              if (firebaseUser == null) {
                yield User.empty;
                return;
              }

              final snapshot = await firestore.userDoc(firebaseUser.uid).get();
              if (!snapshot.exists) {
                yield User.empty; // Only yield empty if document doesn't exist
                return;
              }

              yield User.fromJson(snapshot.data()!);
            },
          )
          .handleError((Object _) => throw UserFailure.fromAuthUserChanges())
          .logOnEach('USER')
          .shareValue();
}

extension Auth on UserRepository {
  // send OTP
  Future<ConfirmationResult?> sendOTP({required String phoneNumber}) async {
    try {
      final result = await _firebaseAuth.signInWithPhoneNumber(phoneNumber);
      return result;
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuth exceptions
      print('Failed to send OTP: ${e.message}');
      return null;
    } catch (e) {
      // Handle other errors
      print('Unexpected error: $e');
      return null;
    }
  }

  // authenticate user
  Future<bool?> authenticateNewUser({
    required ConfirmationResult confirmationResult,
    required String otp,
  }) async {
    try {
      final userCredential = await confirmationResult.confirm(otp);
      return userCredential.additionalUserInfo!.isNewUser;
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuth exceptions
      print('Failed to confirm OTP: ${e.message}');
      return null;
    } catch (e) {
      // Handle other errors
      print('Unexpected error: $e');
      return null;
    }
  }

  // verify phone number
  Future<void> verifyPhone({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) verificationCompleted,
    required void Function(FirebaseAuthException) verificationFailed,
    required void Function(String, int?) codeSent,
    required void Function(String) codeAutoRetrievalTimeout,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: '+1$phoneNumber',
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } on FirebaseAuthException {
      // catch error
      throw UserFailure.fromInvalidPhoneNumber();
    }
  }

  // Signs the user in
  Future<void> signInWithOTP(String otp, String? verificationId) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otp,
      );
      print('got credential');
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      print('signed in with credential');
      final firebaseUser = userCredential.user;
      print('updated firebase user');
      unawaited(_updateUserData(firebaseUser));
    } on FirebaseAuthException catch (e) {
      print('error signing user in $e');
      throw UserFailure.fromPhoneNumberSignIn();
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut()]);
    } on Exception {
      throw UserFailure.fromSignOut();
    }
  }
}

extension Username on UserRepository {
  // check if username is unqiue
  Future<bool> isUsernameUnique(String username) async {
    // query database to see if the username already exists
    final querySnapshot = await _firestore
        .usernameCollection()
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    return querySnapshot.docs.isEmpty;
  }

  // check if the current user has a username
  Future<bool> userHasUsername(String userID) async {
    final usernameDoc = await _firestore.getUsernameDoc(userID);
    return usernameDoc.exists;
  }

  Future<String> fetchUsername(String userID) async {
    try {
      final userDoc = await _firestore.getUsernameDoc(userID);
      if (!userDoc.exists) return userID;
      return userDoc.data()?['username'] as String;
    } catch (e) {
      // Handle errors as needed
      return userID;
    }
  }

  Future<String> fetchCacheUsername(String userID) async {
    if (_usernameCache.containsKey(userID)) {
      return _usernameCache[userID]!;
    }

    final username = await fetchUsername(userID);
    _usernameCache[userID] = username;
    return username;
  }

  String? getCachedUsername(String userID) {
    return _usernameCache[userID];
  }

  /// save username to user doc
  Future<void> saveUsername(String userID, String username) async {
    try {
      // save username in user doc
      await _firestore.setUserDoc(userID, {'username': username});
      // save the username in a separate collection for quick lookup
      await _firestore
          .setUsernameDoc(userID, {'username': username, 'uid': user.uid});
    } on FirebaseException {
      throw UserFailure.fromUpdateUser();
    }
  }
}

extension Friends on UserRepository {
  Future<void> sendFriendRequest(String otherUserID) async {
    try {
      final currentUserID = user.uid;
      final docID = _getSortedDocID(currentUserID, otherUserID);
      await _firestore.collection('friendRequests').doc(docID).set({
        'senderID': currentUserID,
        'receiverID': otherUserID,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      // return failure
      print('error $e');
      throw UserFailure.fromUpdateUser();
    }
  }

  Future<void> cancelFriendRequest(String otherUserID) async {
    try {
      final currentUserID = user.uid;
      final docID = _getSortedDocID(currentUserID, otherUserID);
      await _firestore.collection('friendRequests').doc(docID).delete();
    } on FirebaseException catch (e) {
      // return failure
      print('error $e');
      throw UserFailure.fromUpdateUser();
    }
  }

  Future<void> addFriend(
    String otherUserID,
  ) async {
    // get current user
    final currentUserID = user.uid;
    // sort
    final docID = _getSortedDocID(currentUserID, otherUserID);

    // batch
    final batch = _firestore.batch();

    // docs
    final userRef = _firestore.userDoc(currentUserID);
    final otherUserRef = _firestore.userDoc(otherUserID);
    final friendsRef = _firestore.collection('friends').doc(docID);
    final friendReqRef = _firestore.collection('friendRequests').doc(docID);

    try {
      // make sure users exist
      final userSnapshot = await userRef.get();
      final otherUserSnapshot = await otherUserRef.get();
      if (!userSnapshot.exists || !otherUserSnapshot.exists) {
        throw UserFailure.fromGetUser();
      }

      // add friend
      batch
        ..update(userRef, {'friends': FieldValue.increment(1)})
        ..update(otherUserRef, {'friends': FieldValue.increment(1)})
        ..set(friendsRef, {
          'userID1': currentUserID,
          'userID2': otherUserID,
          'timestamp': FieldValue.serverTimestamp(),
        })
        ..delete(friendReqRef);

      // commit batch
      await batch.commit();
    } on FirebaseException catch (e) {
      // return failure
      print('error $e');
      throw UserFailure.fromUpdateUser();
    }
  }

  Future<void> removeFriend(
    String otherUserID,
  ) async {
    // get current user
    final currentUserID = user.uid;
    // sort
    final docID = _getSortedDocID(currentUserID, otherUserID);

    // batch
    final batch = _firestore.batch();

    // docs
    final userRef = _firestore.userDoc(currentUserID);
    final otherUserRef = _firestore.userDoc(otherUserID);
    final friendsRef = _firestore.collection('friends').doc(docID);

    try {
      // make sure users exist
      final userSnapshot = await userRef.get();
      final otherUserSnapshot = await otherUserRef.get();
      if (!userSnapshot.exists || !otherUserSnapshot.exists) {
        throw UserFailure.fromGetUser();
      }

      // remove friend
      batch
        ..update(userRef, {'friends': FieldValue.increment(-1)})
        ..update(otherUserRef, {'friends': FieldValue.increment(-1)})
        ..delete(friendsRef);

      // commit batch
      await batch.commit();
    } on FirebaseException catch (e) {
      // return failure
      print('error $e');
      throw UserFailure.fromUpdateUser();
    }
  }

  Future<bool> areUsersFriends(String otherUserID) async {
    try {
      final currentUserID = user.uid;
      // sort
      final docID = _getSortedDocID(currentUserID, otherUserID);
      // get doc
      final friendDoc = await _firestore.collection('friends').doc(docID).get();
      return friendDoc.exists;
    } on FirebaseException {
      throw UserFailure.fromGetUser();
    }
  }

  Future<String?> fetchRequestSender(String otherUserID) async {
    try {
      final currentUserID = user.uid;
      // sort
      final docID = _getSortedDocID(currentUserID, otherUserID);
      // get request doc
      final friendRequestDoc =
          await _firestore.collection('friendRequests').doc(docID).get();
      // return sender ID
      if (friendRequestDoc.exists) {
        return friendRequestDoc.data()?['senderID'] as String?;
      } else {
        return null;
      }
    } on FirebaseException {
      throw UserFailure.fromGetUser();
    }
  }

  // get user's friends
  Future<int> fetchFriendCount(String userID) async {
    try {
      // get document from database
      final doc = await _firestore.getUserDoc(userID);
      if (doc.exists) {
        // return likes
        final data = User.fromJson(doc.data()!);
        return data.friends;
      } else {
        return 0;
      }
    } on FirebaseException {
      // return failure
      throw UserFailure.fromGetUser();
    }
  }

  String _getSortedDocID(String docID1, String docID2) {
    return docID1.compareTo(docID2) > 0
        ? '${docID1}_$docID2'
        : '${docID2}_$docID1';
  }
}

extension Create on UserRepository {
  // create new firestore document for user
  Future<void> createUser(String userID, User newUser) async {
    // authenticate user
    try {
      // set username in usernames collection
      await _firestore.setUsernameDoc(userID, {
        'username': newUser.username,
        'uid': userID,
      });
      // set data
      await _firestore.setUserDoc(userID, newUser.toJson());
      await _firestore.setUserDoc(userID, {'memberSince': Timestamp.now()});
    } on FirebaseException {
      throw UserFailure.fromCreateUser();
    }
  }
}

extension Fetch on UserRepository {
  // get user document by ID
  Future<User> fetchUserByID(String userID) async {
    try {
      final docSnapshot = await _firestore.getUserDoc(userID);
      return docSnapshot.exists
          ? User.fromJson(docSnapshot.data()!)
          : User.empty;
    } on FirebaseException {
      UserFailure.fromGetUser();
      return User.empty;
    }
  }

  // get user data
  Future<User> fetchUserData(firebase.User? firebaseUser) async {
    if (firebaseUser == null) return User.empty;
    return User.fromFirebaseUser(firebaseUser);
  }
}

extension Update on UserRepository {
  // update user doc
  Future<void> _updateUserData(firebase.User? firebaseUser) async {
    if (firebaseUser == null) {
      return;
    }
    final uid = firebaseUser.uid;
    final user = User.fromFirebaseUser(firebaseUser);
    return _firestore.userDoc(uid).set(
          user.toJson(),
          SetOptions(
            mergeFields: [
              'uid',
              'lastSignInAt',
            ],
          ),
        );
  }

  // update specific user field
  Future<void> updateField(String userID, String field, String data) async {
    try {
      field == 'username'
          ? await saveUsername(userID, data)
          : await _firestore.updateUserDoc(userID, {field: data});
    } on FirebaseException {
      throw UserFailure.fromUpdateUser();
    }
  }
}

extension Delete on UserRepository {}
