import 'package:api_client/api_client.dart' as firebase show User;
import 'package:api_client/api_client.dart' hide User;
import 'package:app_core/app_core.dart';
import 'package:user_repository/src/failures.dart';
import 'package:user_repository/src/models/friend_model.dart';
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
  late final ValueStream<User> _user;

  /// current user as a stream
  Stream<User> get watchUser => _user.asBroadcastStream();

  /// get the current user's data synchonously
  User get user => _user.valueOrNull ?? User.empty;

  /// Gets the initial [watchUser] emission.
  /// Returns [User.empty] when an error occurs.
  Future<User> getOpeningUser() {
    return watchUser.first.catchError((Object _) => User.empty);
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
  /// watch for changes in auth
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
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      unawaited(_updateUserData(firebaseUser));
    } on FirebaseAuthException {
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
    try {
      final querySnapshot = await _firestore
          .usernameCollection()
          .where('username', isEqualTo: username)
          .limit(1)
          .get();
      return querySnapshot.docs.isEmpty;
    } on FirebaseException {
      throw UserFailure.fromGetUsername();
    }
  }

  // get users username
  Future<String> fetchUsername(String userID) async {
    try {
      final usernameDoc = await _firestore.getUsernameDoc(userID);
      if (!usernameDoc.exists) return userID;
      return usernameDoc.data()?['username'] as String;
    } on FirebaseException {
      throw UserFailure.fromGetUsername();
    }
  }

  // save username to user doc
  Future<void> saveUsername(String userID, String username) async {
    try {
      // save username in user doc
      await _firestore.setUserDoc(userID, {'username': username});
      // save the username in a separate collection for quick lookup
      await _firestore
          .setUsernameDoc(userID, {'username': username, 'uid': user.uid});
    } on FirebaseException {
      throw UserFailure.fromUpdateUsername();
    }
  }
}

extension Friends on UserRepository {
  // modify the friend request to the desired user
  Future<void> modifyFriendRequest(String otherUserID) async {
    try {
      final currentUserID = user.uid;
      final docID = _getSortedDocID(currentUserID, otherUserID);
      final snapshot = await _firestore.getFriendRequestDoc(docID);
      snapshot.exists
          ? await cancelFriendRequest(docID)
          : await sendFriendRequest(currentUserID, otherUserID, docID);
    } on FirebaseException {
      throw UserFailure.fromUpdateFriend();
    }
  }

  Future<void> sendFriendRequest(
    String currentUserID,
    String otherUserID,
    String docID,
  ) async {
    try {
      await _firestore.setFriendDoc(docID, {
        'senderID': currentUserID,
        'receiverID': otherUserID,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException {
      throw UserFailure.fromUpdateFriend();
    }
  }

  Future<void> cancelFriendRequest(String docID) async {
    try {
      await _firestore.deleteFriendRequestDoc(docID);
    } on FirebaseException {
      throw UserFailure.fromUpdateFriend();
    }
  }

  // modify friend status with the desired user
  Future<void> modifyFriend(String otherUserID) async {
    final currentUserID = user.uid;
    final docID = _getSortedDocID(currentUserID, otherUserID);
    final friendsRef = _firestore.friendDoc(docID);
    final userRef = _firestore.friendDoc(currentUserID);
    final otherUserRef = _firestore.friendDoc(otherUserID);
    try {
      final snapshot = await friendsRef.get();
      if (snapshot.exists) {
        await addFriend(
          currentUserID,
          otherUserID,
          docID,
          userRef,
          otherUserRef,
          friendsRef,
        );
      } else {
        await removeFriend(userRef, otherUserRef, friendsRef);
      }
    } on FirebaseException {
      throw UserFailure.fromUpdateFriend();
    }
  }

  Future<void> addFriend(
    String currentUserID,
    String otherUserID,
    String docID,
    DocumentReference userRef,
    DocumentReference otherUserRef,
    DocumentReference friendsRef,
  ) async {
    final batch = _firestore.batch();
    try {
      final friendReqRef = _firestore.friendRequestDoc(docID);
      batch
        ..update(userRef, {'friends': FieldValue.increment(1)})
        ..update(otherUserRef, {'friends': FieldValue.increment(1)})
        ..set(friendsRef, {
          'userID1': currentUserID,
          'userID2': otherUserID,
          'createdAt': FieldValue.serverTimestamp(),
        })
        ..delete(friendReqRef);
      await batch.commit();
    } on FirebaseException {
      throw UserFailure.fromCreateFriend();
    }
  }

  Future<void> removeFriend(
    DocumentReference userRef,
    DocumentReference otherUserRef,
    DocumentReference friendsRef,
  ) async {
    final batch = _firestore.batch();
    try {
      batch
        ..delete(friendsRef)
        ..update(userRef, {'friends': FieldValue.increment(-1)})
        ..update(otherUserRef, {'friends': FieldValue.increment(-1)});

      await batch.commit();
    } on FirebaseException {
      throw UserFailure.fromDeleteFriend();
    }
  }

  // check if friend doc exists
  Future<bool> areUsersFriends(String otherUserID) async {
    try {
      final currentUserID = user.uid;
      final docID = _getSortedDocID(currentUserID, otherUserID);
      final friendDoc = await _firestore.getFriendDoc(docID);
      return friendDoc.exists;
    } on FirebaseException {
      throw UserFailure.fromGetFriend();
    }
  }

  // retrieve the requester's ID
  Future<String?> fetchRequestSender(String otherUserID) async {
    try {
      final currentUserID = user.uid;
      final docID = _getSortedDocID(currentUserID, otherUserID);
      final friendRequestDoc = await _firestore.getFriendDoc(docID);
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

  // get all the user's friend requests
  Future<List<String>> fetchFriendRequests(String userID) async {
    try {
      final senderSnapshots = await _firestore
          .collection('friendRequests')
          .where('receiverID', isEqualTo: userID)
          .orderBy('timestamp', descending: true)
          .get();
      final senderIDs = senderSnapshots.docs
          .map((doc) => doc.data()['senderID'] as String)
          .toList();

      return senderIDs;
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

  // sort doc for easy compounded indecies
  String _getSortedDocID(String docID1, String docID2) {
    return docID1.compareTo(docID2) > 0
        ? '${docID1}_$docID2'
        : '${docID2}_$docID1';
  }

  Future<void> toggleBlockUser(String userID) async {
    try {
      final doc = _firestore.userDoc(user.uid);
      final snapshot = await doc.get();
      if (!snapshot.exists) return;
      final data = User.fromJson(snapshot.data()!);
      if (data.hasUserBlocked(userID)) {
        await doc.update({
          'blockedUsers': FieldValue.arrayRemove([userID]),
        });
      } else {
        await doc.update({
          'blockedUsers': FieldValue.arrayUnion([userID]),
        });
      }
    } on FirebaseException {
      throw UserFailure.fromUpdateFriend();
    }
  }

  Future<bool> isUserBlocked(String userID) async {
    try {
      final snapshot = await _firestore.getUserDoc(userID);
      if (!snapshot.exists) return false;
      final otherUser = User.fromJson(snapshot.data()!);
      return user.hasUserBlocked(userID) || otherUser.hasUserBlocked(user.uid);
    } on FirebaseException {
      throw UserFailure.fromGetUser();
    }
  }

  Stream<List<String>> streamFriends(
    String userID, {
    int pageSize = 25,
    int page = 0,
  }) async* {
    // Fetch documents where current user is either userID1 or userID2
    final friendsQuery1 = _firestore
        .collection('friends')
        .where('userID1', isEqualTo: userID)
        .limit(pageSize * (page + 1));

    final friendsQuery2 = _firestore
        .collection('friends')
        .where('userID2', isEqualTo: userID)
        .limit(pageSize * (page + 1));

    // Combine the results from both queries
    final friendsListSnapshot1 = await friendsQuery1.get();
    final friendsListSnapshot2 = await friendsQuery2.get();

    // Combine the user IDs from both lists (remove duplicates if needed)
    final userIDs = {
      ...friendsListSnapshot1.docs.map((doc) => _getFriendUserId(doc, userID)),
      ...friendsListSnapshot2.docs.map((doc) => _getFriendUserId(doc, userID)),
    }.toList();

    // Stream the paginated users by their IDs
    yield* streamFriendsByIds(pageSize, page, userIDs);
  }

  // Helper function to get the other user's ID
  String _getFriendUserId(DocumentSnapshot doc, String currentUserId) {
    final data = Friend.fromFirestore(doc);
    return data.userID1 == currentUserId ? data.userID2 : data.userID1;
  }

  // Stream paginated users by their IDs
  Stream<List<String>> streamFriendsByIds(
    int pageSize,
    int page,
    List<String> userIDs,
  ) async* {
    final buffer = <String>[];
    final startIndex = page * pageSize;

    if (startIndex >= userIDs.length) {
      yield buffer;
      return;
    }

    final userIDsPage = userIDs.skip(startIndex).take(pageSize).toList();

    // Process documents and add to buffer
    for (final uid in userIDsPage) {
      buffer.add(uid);
    }

    yield buffer;
  }
}

extension Create on UserRepository {
  // create new firestore document for user
  Future<User> createUser(User data) async {
    try {
      final userID = user.uid;
      // set username
      await _firestore.setUsernameDoc(userID, {
        'username': data.username,
        'uid': userID,
      });
      // set user data
      final userData = data.toJson()..addAll({'memberSince': Timestamp.now()});
      await _firestore.setUserDoc(userID, userData);
      return user;
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

  // get users photoURL
  Future<void> setPhotoURL(String photoURL) async {
    try {
      final photoDoc = _firestore.collection('userPhoto').doc(user.uid);
      await photoDoc.set({'photoURL': photoURL, 'uid': user.uid});
    } on FirebaseException {
      throw UserFailure.fromUpdateUser();
    }
  }

  // get users photoURL
  Future<String?> fetchPhotoURL(String userID) async {
    try {
      final photoDoc =
          await _firestore.collection('userPhoto').doc(userID).get();
      if (!photoDoc.exists) return null;
      return photoDoc.data()?['photoURL'] as String;
    } on FirebaseException {
      throw UserFailure.fromGetUser();
    }
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
  Future<void> updateField(
    String userID,
    String field,
    dynamic data,
  ) async {
    try {
      field == 'username'
          ? await saveUsername(userID, data as String)
          : await _firestore.updateUserDoc(userID, {field: data});
    } on FirebaseException {
      throw UserFailure.fromUpdateUser();
    }
  }
}

extension Delete on UserRepository {}
