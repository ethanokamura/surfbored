import 'package:cloud_firestore/cloud_firestore.dart';

extension FirebaseFirestoreExtensions on FirebaseFirestore {
  String createId() => collection('_').doc().id;

  // users
  CollectionReference<Map<String, dynamic>> usersCollection() =>
      collection('users');
  DocumentReference<Map<String, dynamic>> userDoc(String userID) =>
      usersCollection().doc(userID);
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDoc(String userID) =>
      userDoc(userID).get();
  Future<void> updateUserDoc(String userID, Map<String, dynamic> data) =>
      userDoc(userID).update(data);
  Future<void> setUserDoc(String userID, Map<String, dynamic> data) =>
      userDoc(userID).set(data, SetOptions(merge: true));

  // usernames
  CollectionReference<Map<String, dynamic>> usernameCollection() =>
      collection('usernames');
  DocumentReference<Map<String, dynamic>> usernameDoc(String userID) =>
      usernameCollection().doc(userID);
  Future<DocumentSnapshot<Map<String, dynamic>>> getUsernameDoc(
    String userID,
  ) =>
      usernameDoc(userID).get();
  Future<void> updateUsernameDoc(String userID, Map<String, dynamic> data) =>
      usernameDoc(userID).update(data);
  Future<void> setUsernameDoc(String userID, Map<String, dynamic> data) =>
      usernameDoc(userID).set(data);

  // items
  CollectionReference<Map<String, dynamic>> itemsCollection() =>
      collection('items');
  DocumentReference<Map<String, dynamic>> itemDoc(String itemID) =>
      itemsCollection().doc(itemID);
  Future<DocumentSnapshot<Map<String, dynamic>>> getItemDoc(String itemID) =>
      itemDoc(itemID).get();
  Future<void> updateItemDoc(String itemID, Map<String, dynamic> data) =>
      itemDoc(itemID).update(data);
  Future<void> setItemDoc(String itemID, Map<String, dynamic> data) =>
      itemDoc(itemID).set(data);

  // boards
  CollectionReference<Map<String, dynamic>> boardsCollection() =>
      collection('boards');
  DocumentReference<Map<String, dynamic>> boardDoc(String boardID) =>
      boardsCollection().doc(boardID);
  Future<DocumentSnapshot<Map<String, dynamic>>> getBoardDoc(String boardID) =>
      boardDoc(boardID).get();
  Future<void> updateBoardDoc(String boardID, Map<String, dynamic> data) =>
      boardDoc(boardID).update(data);
  Future<void> setBoardDoc(String boardID, Map<String, dynamic> data) =>
      boardDoc(boardID).set(data);
}
