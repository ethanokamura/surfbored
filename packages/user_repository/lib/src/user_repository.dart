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

  // figure out if user exists
  Future<bool> doesUserExist(String userID) async {
    final docSnapshot = await _firestore.getUserDoc(userID);
    return docSnapshot.exists;
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
  /// Signs the [model.User] in anonymously.
  Future<void> signInAnonymously() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();
      final firebaseUser = userCredential.user;
      unawaited(_updateUserData(firebaseUser));
    } on FirebaseAuthException {
      throw UserFailure.fromAnonymousSignIn();
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

  // find the user's username and return it!
  Future<String> getUsername(String userID) async {
    try {
      final snapshot = await _firestore.usernameDoc(userID).get();
      return snapshot.exists ? snapshot.get('username') as String : userID;
    } on FirebaseException {
      throw UserFailure.fromGetUser();
    }
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

  // get boards list
  Future<List<String>> fetchBoards(String userID) async {
    try {
      // get user doc
      final doc = await _firestore.getUserDoc(userID);
      // return empty if the doc does not exist
      if (!doc.exists) return [];
      // get user data
      final userData = model.User.fromJson(doc.data()!);
      // return the user's boards
      return userData.boards;
    } on FirebaseException {
      throw UserFailure.fromGetUser();
    }
  }

  // get post list
  Future<List<String>> fetchPosts(String userID) async {
    try {
      // get user doc
      final doc = await _firestore.getUserDoc(userID);
      // return empty if the doc does not exist
      if (!doc.exists) return [];
      // get user data
      final userData = model.User.fromJson(doc.data()!);
      // return the user's posts
      return userData.posts;
    } on FirebaseException {
      throw UserFailure.fromGetUser();
    }
  }

  // get user's liked posts
  Future<List<String>> fetchLikedPosts(String userID) async {
    try {
      // get user doc
      final doc = await _firestore.getUserDoc(userID);
      // return empty if the doc does not exist
      if (!doc.exists) return [];
      // get user data
      final userData = model.User.fromJson(doc.data()!);
      // return the user's liked posts
      return userData.posts;
    } on FirebaseException {
      throw UserFailure.fromGetUser();
    }
  }

  // get user's boards
  Future<List<String>> fetchSavedBoards(String userID) async {
    try {
      // get user doc
      final doc = await _firestore.getUserDoc(userID);
      // return empty if the doc does not exist
      if (!doc.exists) return [];
      // get user data
      final userData = model.User.fromJson(doc.data()!);
      // return the user's liked boards
      return userData.savedBoards;
    } on FirebaseException {
      throw UserFailure.fromGetUser();
    }
  }
}

extension StreamData on UserRepository {
  // stream board  list
  Stream<List<String>> streamBoards(String userID) {
    try {
      return _firestore.userDoc(userID).snapshots().map((snapshot) {
        if (snapshot.exists) {
          final data = model.User.fromJson(snapshot.data()!);
          return data.boards;
        } else {
          throw UserFailure.fromGetUser();
        }
      });
    } on FirebaseException {
      throw UserFailure.fromGetUser();
    }
  }

  // stream posts list
  Stream<List<String>> streamPosts(String userID) {
    try {
      return _firestore.userDoc(userID).snapshots().map((doc) {
        if (doc.exists) {
          final data = model.User.fromJson(doc.data()!);
          return data.posts;
        } else {
          throw UserFailure.fromGetUser();
        }
      });
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
