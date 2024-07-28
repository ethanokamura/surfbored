import 'dart:io';
import 'package:api_client/api_client.dart' as firebase show User;
import 'package:api_client/api_client.dart' hide User;
import 'package:app_core/app_core.dart';
import 'package:user_repository/src/failures.dart';
import 'package:user_repository/src/models/models.dart' as model;

class UserRepository {
  UserRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _firestore = firestore ?? FirebaseFirestore.instance {
    _user = _firebaseAuth.authUserChanges(_firestore);
  }

  final FirebaseStorage _storage;
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
  model.User getCurrentUser() {
    return user;
  }

  // get current user's ID
  String getCurrentUserID() {
    return _firebaseAuth.currentUser!.uid;
  }

  // get user document by ID
  Future<model.User> getUserById(String userID) async {
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
  Future<model.User> getUserData(firebase.User? firebaseUser) async {
    if (firebaseUser == null) return model.User.empty;
    return model.User.fromFirebaseUser(firebaseUser);
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

  // upload image
  Future<String?> uploadImage(
    File file,
    String doc,
  ) async {
    try {
      // upload to firebase
      final url =
          await _storage.uploadFile('users/$doc/cover_image.jpeg', file);
      // save photoURL to document
      await _firestore.updateUserDoc(doc, {'photoURL': url});
      return url;
    } catch (e) {
      return null;
    }
  }

  // check if the current user is the provided user
  bool isCurrentUser(String userID) {
    return user.uid == userID;
  }

  // check if user has liked an item
  Future<bool> hasLikedItem(String userID, String itemID) async {
    try {
      final userData = await getUserById(userID);
      return userData.hasLikedItem(itemID: itemID);
    } on FirebaseException {
      throw UserFailure.fromGetUser();
    }
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
  Future<void> createUser(String username) async {
    // authenticate user
    final ref = _firestore.userDoc(user.uid);
    try {
      // set username in usernames collection
      await _firestore.setUsernameDoc(user.uid, {
        'username': username,
        'uid': user.uid,
      });

      // create default data
      final data = model.User(
        uid: user.uid,
        username: username,
      );

      // set data
      await ref.set(data.toJson());
      await ref.set({'memberSince': Timestamp.now()});

      // // create likedItemsBoardID
      // final boardID = await boardService.createBoard(
      //   BoardData(
      //     title: 'Liked Activities:',
      //     description: 'A collection of activities you have liked!',
      //   ),
      // );

      // // update user doc
      // await ref.update({'likedItemsBoardID': boardID});
    } on FirebaseException {
      throw UserFailure.fromCreateUser();
    }
  }
}

extension GetData on UserRepository {
  // get boards list
  Future<List<String>> getBoards(String userID) async {
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

  // get item list
  Future<List<String>> getItems(String userID) async {
    try {
      // get user doc
      final doc = await _firestore.getUserDoc(userID);
      // return empty if the doc does not exist
      if (!doc.exists) return [];
      // get user data
      final userData = model.User.fromJson(doc.data()!);
      // return the user's items
      return userData.items;
    } on FirebaseException {
      throw UserFailure.fromGetUser();
    }
  }

  // stream board  list
  Stream<List<String>> streamBoards(String userID) {
    try {
      return _firestore.userDoc(userID).snapshots().map((snapshot) {
        if (snapshot.exists) {
          final data = model.User.fromJson(snapshot.data()!);
          return data.boards;
        } else {
          throw Exception('Item not found');
        }
      });
    } on FirebaseException {
      throw UserFailure.fromGetUser();
    }
  }

  // stream items list
  Stream<List<String>> streamItems(String userID) {
    try {
      return _firestore.userDoc(userID).snapshots().map((doc) {
        if (doc.exists) {
          final data = model.User.fromJson(doc.data()!);
          return data.items;
        } else {
          throw Exception('items not found');
        }
      });
    } on FirebaseException {
      throw UserFailure.fromGetUser();
    }
  }

  // get user's liked items
  Future<List<String>> getLikedItems(String userID) async {
    try {
      // get user doc
      final doc = await _firestore.getUserDoc(userID);
      // return empty if the doc does not exist
      if (!doc.exists) return [];
      // get user data
      final userData = model.User.fromJson(doc.data()!);
      // return the user's liked items
      return userData.items;
    } on FirebaseException {
      throw UserFailure.fromGetUser();
    }
  }

  // get user's boards
  Future<List<String>> getLikedBoards(String userID) async {
    try {
      // get user doc
      final doc = await _firestore.getUserDoc(userID);
      // return empty if the doc does not exist
      if (!doc.exists) return [];
      // get user data
      final userData = model.User.fromJson(doc.data()!);
      // return the user's liked boards
      return userData.likedBoards;
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
