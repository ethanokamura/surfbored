// dart packages
import 'dart:async';

// utils
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rando/services/firestore/board_service.dart';
import 'package:rando/services/firestore/firestore.dart';
import 'package:rando/services/models.dart';

// Firestore UserData Service Provider
class UserService extends FirestoreService {
  UserService() : super();

  BoardService boardService = BoardService();

  /// check if the given [username] is unique
  /// [returns] a boolean
  Future<bool> isUsernameUnique(String username) async {
    // query database to see if the username already exists
    var querySnapshot = await db
        .collection('usernames')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    return querySnapshot.docs.isEmpty;
  }

  // check if the current user has a username
  Future<bool> userHasUsername() async {
    var user = auth.user!;
    var userDoc = await db.collection('users').doc(user.uid).get();
    return userDoc.exists && userDoc.data()!.containsKey('username');
  }

  // find the user's username and return it!
  Future<String> getUsername(String userID) async {
    try {
      var snapshot = await db.collection('usernames').doc(userID).get();
      return snapshot.exists ? snapshot.get('username') : userID;
    } catch (e) {
      logger.e('error retrieving username $e}');
      return userID;
    }
  }

  /// save username to user doc
  Future<void> saveUsername(String uid, String username) async {
    // get current user and a reference to their firestore doc
    var userRef = db.collection('users').doc(uid);
    var usernameRef = db.collection('usernames').doc(uid);
    try {
      // create batch
      WriteBatch batch = db.batch();

      // save the username in a separate collection for quick lookup
      batch.set(usernameRef, {'username': username, 'uid': uid});

      // save username in user doc
      batch.set(
        userRef,
        {'username': username},
        SetOptions(merge: true),
      );

      // commit changes
      batch.commit();
    } catch (e) {
      logger.e("Error creating user data $e");
    }
  }

  // create new firestore document for user
  Future<void> createUser(String username) async {
    // get current user and a reference to their firestore doc
    var user = auth.user!;
    var userRef = db.collection('users').doc(user.uid);
    var usernameRef = db.collection('usernames').doc(user.uid);
    try {
      WriteBatch batch = db.batch();

      // save the username in a separate collection for quick lookup
      batch.set(usernameRef, {
        'username': username,
        'uid': user.uid,
      });

      // create new UserData object to store userdata
      UserData data = UserData(
        uid: user.uid,
        username: username,
      );

      // set values for user in firestore
      batch.set(userRef, data.toJson());

      // create liked board and get ID
      String boardID = await boardService.createBoard(BoardData(
        title: "Liked Activities:",
        description: "A collection of activities you have liked!",
      ));

      // set user's likedItemsBoardID to the result
      batch.update(userRef, {'likedItemsBoardID': boardID});

      // commit changes
      batch.commit();
    } catch (e) {
      logger.e("Error creating user data $e");
    }
  }

  // return the user's document from firestore as UserData
  Future<UserData> getUserData(String userID) async {
    // get a reference of that item
    var ref = db.collection('users').doc(userID);
    // get snapshot
    var snapshot = await ref.get();
    // return data if it exists
    return snapshot.exists
        ? UserData.fromJson(snapshot.data() ?? {})
        : UserData();
  }

  // stream the user's document from firestore as UserData
  Stream<UserData> getUserStream(String userID) {
    return db.collection('users').doc(userID).snapshots().map((doc) {
      return UserData.fromJson(doc.data() as Map<String, dynamic>);
    });
  }

  // return a stream of the given user's activites from firestore
  Stream<List<ItemData>> readUserItemStream(String userID) {
    // get reference from database
    var userRef = db.collection('users').doc(userID);
    // return the a map of items
    return userRef.snapshots().asyncMap((userSnapshot) async {
      // get all the uid of the activites the user has
      List<String> itemIDs = List.from(userSnapshot.data()?['items'] ?? []);
      // get references to each item
      var itemRefs =
          itemIDs.map((id) => db.collection('items').doc(id)).toList();
      // get data from the items
      var itemSnapshots = await Future.wait(itemRefs.map((ref) => ref.get()));
      // return the mapped data as ItemData
      return itemSnapshots
          .map((snapshot) => ItemData.fromFirestore(snapshot))
          .toList();
    });
  }

  // return a stream of the given user's boards from firestore
  Stream<List<BoardData>> readUserBoardStream(String userID) {
    // get reference from database
    var userRef = db.collection('users').doc(userID);
    // return the map of boards
    return userRef.snapshots().asyncMap((userSnapshot) async {
      // get a list of all the boards in the user's doc
      List<String> boardIDs = List.from(userSnapshot.data()?['boards'] ?? []);
      // get references to each board
      var boardRefs =
          boardIDs.map((id) => db.collection('boards').doc(id)).toList();
      // get data from the boards
      var boardSnapshots = await Future.wait(boardRefs.map((ref) => ref.get()));
      // return the mapped data as BoardData
      return boardSnapshots
          .map((snapshot) => BoardData.fromFirestore(snapshot))
          .toList();
    });
  }

  // get a list of the user's liked items by ID
  Future<List<String>> getLikedItems(String userID) async {
    try {
      // get reference from database
      var ref = db.collection('users').doc(userID);
      // get the data from firestore
      var snapshot = await ref.get();
      // return empty if the doc does not exist
      if (!snapshot.exists) return [];
      // get likedItems from user's doc
      var likedItems = UserData.fromFirestore(snapshot).likedItems;
      // return the user's liked items
      return likedItems;
    } catch (e) {
      logger.e("error getting user's liked items $e");
      return [];
    }
  }

  // finds if the user has liked the given item
  Future<bool> hasUserLikedItem(String userID, String itemID) async {
    try {
      // get reference from database
      var ref = db.collection('users').doc(userID);
      // get data from firestore
      var snapshot = await ref.get();
      // return empty if doc does not exist
      return snapshot.exists &&
          UserData.fromFirestore(snapshot).likedItems.contains(itemID);
    } catch (e) {
      logger.e("error checking liked items: $e");
      return false;
    }
  }
}
