import 'package:api_client/api_client.dart';

extension FirebaseFirestoreExtensions on FirebaseFirestore {
  String createId() => collection('_').doc().id;

  Future<void> processQueryInBatches(
    Query query,
    WriteBatch batch,
    void Function(DocumentSnapshot) processDoc,
  ) async {
    final snapshot = await query.get();
    for (final doc in snapshot.docs) {
      processDoc(doc);
    }
    if (snapshot.docs.length == 500) {
      await processQueryInBatches(
        query.startAfterDocument(snapshot.docs.last),
        batch,
        processDoc,
      );
    }
  }

  Future<void> deleteDocumentsByQuery(Query query, WriteBatch batch) async {
    const batchSize = 500;
    try {
      final querySnapshot = await query.limit(batchSize).get();
      if (querySnapshot.docs.isEmpty) return;
      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      if (querySnapshot.size == batchSize) {
        await deleteDocumentsByQuery(query, batch);
      }
    } catch (e) {
      throw FirebaseException(
        plugin: 'cloud_firestore',
        message: 'Failed to delete documents $e',
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

  // comments
  CollectionReference<Map<String, dynamic>> commentsCollection(String postID) =>
      postDoc(postID).collection('comments');
  DocumentReference<Map<String, dynamic>> commentDoc(
    String postID,
    String commentID,
  ) =>
      commentsCollection(postID).doc(commentID);
  Future<DocumentSnapshot<Map<String, dynamic>>> getCommentDoc(
    String postID,
    String commentID,
  ) =>
      commentDoc(postID, commentID).get();
  Future<void> updateCommentDoc(
    String postID,
    String commentID,
    Map<String, dynamic> data,
  ) =>
      commentDoc(postID, commentID).update(data);
  Future<void> setCommentDoc(
    String postID,
    String commentID,
    Map<String, dynamic> data,
  ) =>
      commentDoc(postID, commentID).set(data);

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
  DocumentReference<Map<String, dynamic>> likeDoc(String likeDocID) =>
      likesCollection().doc(likeDocID);
  Future<DocumentSnapshot<Map<String, dynamic>>> getLikeDoc(String likeDocID) =>
      likeDoc(likeDocID).get();
  Future<void> updateLikeDoc(String likeDocID, Map<String, dynamic> data) =>
      likeDoc(likeDocID).update(data);
  Future<void> setLikeDoc(String likeDocID, Map<String, dynamic> data) =>
      likeDoc(likeDocID).set(data);

  // saves
  CollectionReference<Map<String, dynamic>> savesCollection() =>
      collection('saves');
  DocumentReference<Map<String, dynamic>> savesDoc(String saveDocID) =>
      savesCollection().doc(saveDocID);
  Future<DocumentSnapshot<Map<String, dynamic>>> getSavesDoc(
    String saveDocID,
  ) =>
      savesDoc(saveDocID).get();
  Future<void> updateSavesDoc(String saveDocID, Map<String, dynamic> data) =>
      savesDoc(saveDocID).update(data);
  Future<void> setSavesDoc(String saveDocID, Map<String, dynamic> data) =>
      savesDoc(saveDocID).set(data);

  // friendRequests
  CollectionReference<Map<String, dynamic>> friendRequestCollection() =>
      collection('friendRequests');
  DocumentReference<Map<String, dynamic>> friendRequestDoc(String docID) =>
      friendRequestCollection().doc(docID);
  Future<DocumentSnapshot<Map<String, dynamic>>> getFriendRequestDoc(
    String docID,
  ) =>
      friendRequestDoc(docID).get();
  Future<void> updateFriendRequestDoc(
    String docID,
    Map<String, dynamic> data,
  ) =>
      friendRequestDoc(docID).update(data);
  Future<void> setFriendRequestDoc(String docID, Map<String, dynamic> data) =>
      friendRequestDoc(docID).set(data, SetOptions(merge: true));
  Future<void> deleteFriendRequestDoc(String docID) =>
      friendRequestDoc(docID).delete();

  // friends
  CollectionReference<Map<String, dynamic>> friendCollection() =>
      collection('friends');
  DocumentReference<Map<String, dynamic>> friendDoc(String docID) =>
      friendCollection().doc(docID);
  Future<DocumentSnapshot<Map<String, dynamic>>> getFriendDoc(String docID) =>
      friendDoc(docID).get();
  Future<void> updateFriendDoc(String docID, Map<String, dynamic> data) =>
      friendDoc(docID).update(data);
  Future<void> setFriendDoc(String docID, Map<String, dynamic> data) =>
      friendDoc(docID).set(data, SetOptions(merge: true));
  Future<void> deleteFriendDoc(String docID) => friendDoc(docID).delete();
}
