import 'package:api_client/api_client.dart' as firebase show User;
import 'package:api_client/api_client.dart' hide User;
import 'package:app_core/app_core.dart';
import 'package:user_repository/src/failures.dart';
import 'package:user_repository/src/models/models.dart' as model;

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

  late final ValueStream<model.User> _user;

  // current user as a stream
  Stream<model.User> get watchUser => _user.asBroadcastStream();

  // get the current user's data synchonously
  model.User get user => _user.valueOrNull ?? model.User.empty;

  /// Gets the initial [watchUser] emission.
  ///
  /// Returns [model.User.empty] when an error occurs.
  Future<model.User> getOpeningUser() {
    return watchUser.first.catchError((Object _) => model.User.empty);
  }

  // get the current user
  model.User fetchCurrentUser() {
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
  Stream<model.User> watchUserByID(String userID) {
    return _firestore.userDoc(userID).snapshots().map(
      (snapshot) {
        return snapshot.exists
            ? model.User.fromJson(snapshot.data()!)
            : model.User.empty;
      },
    );
  }
}

extension _FirebaseAuthExtensions on FirebaseAuth {
  ValueStream<model.User> authUserChanges(FirebaseFirestore firestore) =>
      authStateChanges()
          .onErrorResumeWith((_, __) => null)
          .switchMap<model.User>(
            (firebaseUser) async* {
              if (firebaseUser == null) {
                yield model.User.empty;
                return;
              }

              yield* firestore.userDoc(firebaseUser.uid).snapshots().map(
                    (snapshot) => snapshot.exists
                        ? model.User.fromJson(snapshot.data()!)
                        : model.User.empty,
                  );
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
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: otp,
    );
    try {
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
      await _firebaseAuth.signOut();
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
  Future<bool> userHasUsername() async {
    final userDoc = await _firestore.getUserDoc(user.uid);
    return userDoc.exists && userDoc.data()!.containsKey('username');
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
  Future<void> sendFriendRequest(String senderID, String recieverID) async {
    await _firestore
        .collection('friendRequests')
        .doc('${senderID}_$recieverID')
        .set({
      'senderID': senderID,
      'recieverID': recieverID,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeFriendRequest(String senderID, String recieverID) async {
    await _firestore
        .collection('friendRequests')
        .doc('${senderID}_$recieverID')
        .delete();
  }

  Future<void> acceptFriendRequest(
    String requestID,
    String senderID,
    String recieverID,
  ) async {
    await _firestore.collection('friendRequests').doc(requestID).delete();

    await _firestore.updateUserDoc(
      senderID,
      {'friends': FieldValue.increment(1)},
    );
    await _firestore.updateUserDoc(
      recieverID,
      {'friends': FieldValue.increment(1)},
    );
    await _firestore.collection('friends').doc('${senderID}_$recieverID').set({
      'senderID': senderID,
      'recieverID': recieverID,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

extension Create on UserRepository {
  // create new firestore document for user
  Future<void> createUser(String userID, model.User newUser) async {
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
  Future<model.User> fetchUserByID(String userID) async {
    try {
      final docSnapshot = await _firestore.getUserDoc(userID);
      return docSnapshot.exists
          ? model.User.fromJson(docSnapshot.data()!)
          : model.User.empty;
    } on FirebaseException {
      UserFailure.fromGetUser();
      return model.User.empty;
    }
  }

  // get user data
  Future<model.User> fetchUserData(firebase.User? firebaseUser) async {
    if (firebaseUser == null) return model.User.empty;
    return model.User.fromFirebaseUser(firebaseUser);
  }
}

extension Update on UserRepository {
  // update user doc
  Future<void> _updateUserData(firebase.User? firebaseUser) async {
    if (firebaseUser == null) {
      return;
    }
    final uid = firebaseUser.uid;
    final user = model.User.fromFirebaseUser(firebaseUser);
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
