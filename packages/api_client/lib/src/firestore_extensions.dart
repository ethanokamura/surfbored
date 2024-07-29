import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

extension FirebaseFirestoreExtensions on FirebaseFirestore {
  String createId() => collection('_').doc().id;

  // upload image
  Future<String?> uploadImage(
    String collection,
    String doc,
    File file,
  ) async {
    try {
      // upload to firebase
      final url = await FirebaseStorage.instance
          .uploadFile('$collection/$doc/cover_image.jpeg', file);
      // save photoURL to document
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(doc)
          .update({'photoURL': url});
      return url;
    } catch (e) {
      return null;
    }
  }

  Future<void> _processQueryInBatches(
    Query query,
    WriteBatch batch,
    void Function(DocumentSnapshot) processDoc,
  ) async {
    final snapshot = await query.get();
    for (final doc in snapshot.docs) {
      processDoc(doc);
    }
    if (snapshot.docs.length == 500) {
      await _processQueryInBatches(
        query.startAfterDocument(snapshot.docs.last),
        batch,
        processDoc,
      );
    }
  }

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

  // posts
  CollectionReference<Map<String, dynamic>> postsCollection() =>
      collection('posts');
  DocumentReference<Map<String, dynamic>> postDoc(String postID) =>
      postsCollection().doc(postID);
  Future<DocumentSnapshot<Map<String, dynamic>>> getPostDoc(String postID) =>
      postDoc(postID).get();
  Future<void> updatePostDoc(String postID, Map<String, dynamic> data) =>
      postDoc(postID).update(data);
  Future<void> setPostDoc(String postID, Map<String, dynamic> data) =>
      postDoc(postID).set(data);

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

  // likes
  CollectionReference<Map<String, dynamic>> likesCollection() =>
      collection('likes');
  DocumentReference<Map<String, dynamic>> likeDoc(String postID) =>
      likesCollection().doc(postID);
  Future<DocumentSnapshot<Map<String, dynamic>>> getLikeDoc(String postID) =>
      likeDoc(postID).get();
  Future<void> updateLikeDoc(String postID, Map<String, dynamic> data) =>
      likeDoc(postID).update(data);
  Future<void> setLikeDoc(String postID, Map<String, dynamic> data) =>
      likeDoc(postID).set(data);

  // saves
  CollectionReference<Map<String, dynamic>> savesCollection() =>
      collection('saves');
  DocumentReference<Map<String, dynamic>> savesDoc(String boardID) =>
      savesCollection().doc(boardID);
  Future<DocumentSnapshot<Map<String, dynamic>>> getSavesDoc(String boardID) =>
      savesDoc(boardID).get();
  Future<void> updateSavesDoc(String boardID, Map<String, dynamic> data) =>
      savesDoc(boardID).update(data);
  Future<void> setSavesDoc(String boardID, Map<String, dynamic> data) =>
      savesDoc(boardID).set(data);
}
