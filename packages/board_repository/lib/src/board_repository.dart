import 'package:api_client/api_client.dart';
import 'package:board_repository/board_repository.dart';

class BoardRepository {
  BoardRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
}

extension Create on BoardRepository {
  // create a board
  Future<String> createBoard(Board board, String userID) async {
    try {
      final boardRef = _firestore.boardsCollection().doc();

      // set data
      final newBoard = board.toJson();
      newBoard['id'] = boardRef.id;
      newBoard['uid'] = userID;
      newBoard['createdAt'] = Timestamp.now();

      // post data
      await boardRef.set(newBoard);
      await _firestore.setSavesDoc(boardRef.id, {'users': <String>[]});
      await _firestore.updateUserDoc(userID, {
        'boards': FieldValue.arrayUnion([boardRef.id]),
      });

      // return doc ID
      return boardRef.id;
    } on FirebaseException {
      throw BoardFailure.fromCreateBoard();
    }
  }
}

extension Fetch on BoardRepository {
  // get board document
  Future<Board> fetchBoard(String boardID) async {
    try {
      // get document from database
      final doc = await _firestore.getBoardDoc(boardID);
      if (doc.exists) {
        // return board
        return Board.fromJson(doc.data()!);
      } else {
        // return empty board if document DNE
        return Board.empty;
      }
    } on FirebaseException {
      // return failure
      throw BoardFailure.fromGetBoard();
    }
  }

  // get board posts
  Future<List<String>> fetchPosts(String boardID) async {
    try {
      // get document from database
      final doc = await _firestore.getBoardDoc(boardID);
      if (doc.exists) {
        // return board
        final data = Board.fromJson(doc.data()!);
        return data.posts;
      } else {
        // return empty board if document DNE
        return [];
      }
    } on FirebaseException {
      // return failure
      throw BoardFailure.fromGetBoard();
    }
  }
}

extension StreamData on BoardRepository {
  // stream board data
  Stream<Board> streamBoard(String boardID) {
    try {
      return _firestore.boardDoc(boardID).snapshots().map((snapshot) {
        if (snapshot.exists) {
          return Board.fromJson(snapshot.data()!);
        } else {
          throw BoardFailure.fromGetBoard();
        }
      });
    } on FirebaseException {
      throw BoardFailure.fromGetBoard();
    }
  }

  // stream board posts
  Stream<List<String>> streamPosts(String boardID) {
    try {
      return _firestore.boardDoc(boardID).snapshots().map((snapshot) {
        if (snapshot.exists) {
          final data = Board.fromJson(snapshot.data()!);
          return data.posts;
        } else {
          throw BoardFailure.fromGetBoard();
        }
      });
    } on FirebaseException {
      throw BoardFailure.fromGetBoard();
    }
  }
}

extension Update on BoardRepository {
  // update specific user field
  Future<void> updateField(String boardID, String field, String data) async {
    try {
      await _firestore.updateBoardDoc(boardID, {field: data});
    } on FirebaseException {
      throw BoardFailure.fromUpdateBoard();
    }
  }

  // update board posts
  Future<void> updateBoardPosts({
    required String boardID,
    required String postID,
    required bool isSelected,
  }) async {
    try {
      // update based on if the board is selected
      await _firestore.updateBoardDoc(boardID, {
        'posts': !isSelected
            ? FieldValue.arrayUnion([postID])
            : FieldValue.arrayRemove([postID]),
      });
    } on FirebaseException {
      // return failure
      throw BoardFailure.fromUpdateBoard();
    }
  }

  // update board saves
  Future<void> updateBoardSaves({
    required String userID,
    required String boardID,
    required bool isLiked,
  }) async {
    try {
      // get document references
      final userRef = _firestore.userDoc(userID);
      final postRef = _firestore.postDoc(boardID);
      final savesRef = _firestore.likeDoc(boardID);

      // user batch to perform atomic operation
      final batch = _firestore.batch();

      // get document data
      final userSnapshot = await userRef.get();
      final postSnapshot = await postRef.get();
      final saveSnapshot = await savesRef.get();

      // make sure user exists
      if (!userSnapshot.exists ||
          !postSnapshot.exists ||
          !saveSnapshot.exists) {
        throw BoardFailure.fromUpdateBoard();
      }

      if (!isLiked) {
        batch
          ..update(userRef, {
            'savedBoards': FieldValue.arrayUnion([boardID]),
          })
          ..update(savesRef, {
            'users': FieldValue.arrayUnion([userID]),
          })
          ..update(postRef, {
            'saves': FieldValue.increment(1),
          });
      } else {
        batch
          ..update(userRef, {
            'savedBoards': FieldValue.arrayRemove([boardID]),
          })
          ..update(savesRef, {
            'users': FieldValue.arrayRemove([userID]),
          })
          ..update(postRef, {
            'saves': FieldValue.increment(-1),
          });
      }
      // commit changes
      await batch.commit();
    } on FirebaseException {
      throw BoardFailure.fromUpdateBoard();
    }
  }
}

extension Delete on BoardRepository {
  // delete post:
  // we need to delete the post at all reference points
  Future<void> deleteBoard(
    String userID,
    String boardID,
    String photoURL,
  ) async {
    // start batch
    final batch = _firestore.batch();

    // get references
    final boardRef = _firestore.boardDoc(boardID);
    final saveRef = _firestore.savesDoc(boardID);
    const batchSize = 500; // Firestore batch limit

    try {
      final boardDoc = await boardRef.get();
      if (!boardDoc.exists) {
        throw BoardFailure.fromGetBoard();
      }

      batch
        ..delete(boardRef)
        ..delete(saveRef);

      // find all boards containing this post
      final boardsQuery = _firestore
          .boardsCollection()
          .where('boards', arrayContains: boardID)
          .limit(batchSize);

      await _firestore._processQueryInBatches(boardsQuery, batch, (boardDoc) {
        batch.update(boardDoc.reference, {
          'boards': FieldValue.arrayRemove([boardID]),
        });
      });

      // find all users who liked this post
      var usersQuery = _firestore
          .collection('users')
          .where('savedBoards', arrayContains: boardID)
          .limit(batchSize);

      await _firestore._processQueryInBatches(usersQuery, batch, (userDoc) {
        batch.update(userDoc.reference, {
          'savedBoards': FieldValue.arrayRemove([boardID]),
        });
      });

      // find all users who liked this post
      usersQuery = _firestore
          .collection('users')
          .where('boards', arrayContains: boardID)
          .limit(batchSize);

      await _firestore._processQueryInBatches(usersQuery, batch, (userDoc) {
        batch.update(userDoc.reference, {
          'boards': FieldValue.arrayRemove([boardID]),
        });
      });

      // Optionally delete the associated image file
      if (photoURL.isNotEmpty) {
        await _storage.refFromURL(photoURL).delete();
      }
      // commit changes
      await batch.commit();
    } on FirebaseException {
      throw BoardFailure.fromDeleteBoard();
    }
  }
}
