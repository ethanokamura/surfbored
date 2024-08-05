import 'package:api_client/api_client.dart';
import 'package:tag_repository/src/failures.dart';

class TagRepository {
  TagRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> tagDoc(String tagID) =>
      _firestore.collection('tags').doc(tagID);
  DocumentReference<Map<String, dynamic>> userTagDoc(String tagID) =>
      _firestore.collection('userTags').doc(tagID);
  DocumentReference<Map<String, dynamic>> postTagDoc(String tagID) =>
      _firestore.collection('postTags').doc(tagID);
  DocumentReference<Map<String, dynamic>> boardTagDoc(String tagID) =>
      _firestore.collection('boardTags').doc(tagID);
}

extension Users on TagRepository {
  Future<void> addUserTag(String userID, String tagID) async {
    final tagRef = tagDoc(tagID);
    final userTagRef = userTagDoc(tagID);

    final batch = _firestore.batch();

    try {
      batch
        ..update(tagRef, {
          'usageCount': FieldValue.increment(1),
        })
        ..update(userTagRef, {
          'users': FieldValue.arrayUnion([userID]),
        });

      await batch.commit();
    } on FirebaseException {
      throw TagFailure.fromUpdateTag();
    }
  }

  Future<void> removeUserTag(String userID, String tagID) async {
    final tagRef = tagDoc(tagID);
    final userTagRef = userTagDoc(tagID);

    final batch = _firestore.batch();

    try {
      final tagSnapshot = await tagRef.get();
      final userTagSnapshot = await userTagRef.get();

      if (!tagSnapshot.exists || !userTagSnapshot.exists) {
        throw TagFailure.fromUpdateTag();
      }

      batch
        ..update(tagRef, {
          'usageCount': FieldValue.increment(-1),
        })
        ..update(userTagRef, {
          'users': FieldValue.arrayRemove([userID]),
        });

      await batch.commit();
    } on FirebaseException {
      throw TagFailure.fromUpdateTag();
    }
  }

  Future<List<String>> getUserTagsByTagID(String tagID) async {
    final snapshot = await userTagDoc(tagID).get();
    if (snapshot.exists) {
      return List<String>.from(snapshot.data()!['users'] as List<String>);
    } else {
      return [];
    }
  }
}

extension Posts on TagRepository {
  Future<void> addPostTag(String postID, String tagID) async {
    final tagRef = tagDoc(tagID);
    final postTagRef = postTagDoc(tagID);

    final batch = _firestore.batch();

    try {
      batch
        ..update(tagRef, {
          'usageCount': FieldValue.increment(1),
        })
        ..update(postTagRef, {
          'posts': FieldValue.arrayUnion([postID]),
        });

      await batch.commit();
    } on FirebaseException {
      throw TagFailure.fromUpdateTag();
    }
  }

  Future<void> removePostTag(String postID, String tagID) async {
    final tagRef = tagDoc(tagID);
    final postTagRef = postTagDoc(tagID);

    final batch = _firestore.batch();

    try {
      final tagSnapshot = await tagRef.get();
      final postTagSnapshot = await postTagRef.get();

      if (!tagSnapshot.exists || !postTagSnapshot.exists) {
        throw TagFailure.fromUpdateTag();
      }

      batch
        ..update(tagRef, {
          'usageCount': FieldValue.increment(-1),
        })
        ..update(postTagRef, {
          'posts': FieldValue.arrayRemove([postID]),
        });

      await batch.commit();
    } on FirebaseException {
      throw TagFailure.fromUpdateTag();
    }
  }

  Future<List<String>> getPostTagsByTagID(String tagID) async {
    final snapshot = await postTagDoc(tagID).get();
    if (snapshot.exists) {
      return List<String>.from(snapshot.data()!['posts'] as List<String>);
    } else {
      return [];
    }
  }
}

extension Boards on TagRepository {
  Future<void> addBoardTag(String boardID, String tagID) async {
    final tagRef = tagDoc(tagID);
    final boardTagRef = boardTagDoc(tagID);

    final batch = _firestore.batch();

    try {
      batch
        ..update(tagRef, {
          'usageCount': FieldValue.increment(1),
        })
        ..update(boardTagRef, {
          'boards': FieldValue.arrayUnion([boardID]),
        });

      await batch.commit();
    } on FirebaseException {
      throw TagFailure.fromUpdateTag();
    }
  }

  Future<void> removeBoardTag(String boardID, String tagID) async {
    final tagRef = tagDoc(tagID);
    final boardTagRef = boardTagDoc(tagID);

    final batch = _firestore.batch();

    try {
      final tagSnapshot = await tagRef.get();
      final boardTagSnapshot = await boardTagRef.get();

      if (!tagSnapshot.exists || !boardTagSnapshot.exists) {
        throw TagFailure.fromUpdateTag();
      }

      batch
        ..update(tagRef, {
          'usageCount': FieldValue.increment(-1),
        })
        ..update(boardTagRef, {
          'boards': FieldValue.arrayRemove([boardID]),
        });

      await batch.commit();
    } on FirebaseException {
      throw TagFailure.fromUpdateTag();
    }
  }

  Future<List<String>> getBoardTagsByTagID(String tagID) async {
    final snapshot = await boardTagDoc(tagID).get();
    if (snapshot.exists) {
      return List<String>.from(snapshot.data()!['boards'] as List<String>);
    } else {
      return [];
    }
  }
}
