// dart packages
import 'dart:async';
import 'package:logger/logger.dart';
// import 'package:rxdart/rxdart.dart';

// utils
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rando/services/auth.dart';
import 'package:rando/services/models.dart';

class UserService {
  // firestore database
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final AuthService auth = AuthService();
  final Logger logger = Logger();

  // Check if Username is Unique
  Future<bool> isUsernameUnique(String username) async {
    var querySnapshot = await db
        .collection('usernames')
        .where('username', isEqualTo: username)
        .get();
    return querySnapshot.docs.isEmpty;
  }

  // Save Username
  Future<void> saveUsername(String username) async {
    var user = auth.user!;
    var userRef = db.collection('users').doc(user.uid);

    // save the username in a separate collection for quick lookup
    await db.collection('usernames').doc(user.uid).set({
      'username': username,
      'uid': user.uid,
    });

    // save username in user doc
    await userRef.set({
      'username': username,
    }, SetOptions(merge: true));
  }

  // Check if the current user has a username
  Future<bool> userHasUsername() async {
    var user = auth.user!;
    var userDoc = await db.collection('users').doc(user.uid).get();
    return userDoc.exists && userDoc.data()!.containsKey('username');
  }

  Future<String> getUsername(String userID) async {
    try {
      var snapshot = await db.collection('usernames').doc(userID).get();
      if (snapshot.exists) {
        return snapshot.get('username');
      } else {
        return userID;
      }
    } catch (e) {
      logger.e('error retrieving username $e}');
      return userID;
    }
  }

  // Read a Single List of Items:
  Future<UserData> getUserData(String userID) async {
    // get a reference of that item
    var ref = db.collection('users').doc(userID);
    // get snapshot
    var snapshot = await ref.get();
    if (snapshot.exists) {
      return UserData();
    }
    // convert to note model from model.dart
    return UserData.fromJson(snapshot.data() ?? {});
  }

  Stream<UserData> getUserStream(String userID) {
    try {
      return db
          .collection('users')
          .doc(userID)
          .snapshots()
          .map((doc) => UserData.fromJson(doc.data() as Map<String, dynamic>));
    } catch (e) {
      logger.e("error fetching user data $e");
      rethrow;
    }
  }

  // Set user's photo URL path
  Future<void> setUserPhotoURL(String userID, String filename) async {
    var userRef = db.collection('users').doc(userID);
    // save profilePicturePath in user doc
    await userRef.set(
      {'imgURL': 'users/$userID/$filename'},
      SetOptions(merge: true),
    );
  }

  Stream<List<ItemData>> readUserItemStream(String userID) {
    var userRef = db.collection('users').doc(userID);
    return userRef.snapshots().asyncMap((userSnapshot) async {
      List<String> itemIDs = List.from(userSnapshot.data()?['items'] ?? []);
      var itemRefs =
          itemIDs.map((id) => db.collection('items').doc(id)).toList();
      var itemSnapshots = await Future.wait(itemRefs.map((ref) => ref.get()));
      return itemSnapshots
          .map((snapshot) => ItemData.fromFirestore(snapshot))
          .toList();
    });
  }

  Future<List<String>> getUserItemLikes(String userID) async {
    var ref = db.collection('users').doc(userID);
    var snapshot = await ref.get();
    if (snapshot.exists) {
      return UserData().likedItems;
    }
    return [];
  }

  Future<bool> userLikesItem(String userID, String itemID) async {
    try {
      var ref = db.collection('users').doc(userID);
      var snapshot = await ref.get();
      if (!snapshot.exists) return false;

      var userData = UserData.fromFirestore(snapshot);
      return userData.likedItems.contains(itemID);
    } catch (e) {
      logger.e("error checking liked items: $e");
      return false;
    }
  }
}
