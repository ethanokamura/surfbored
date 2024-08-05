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
    final batch = _firestore.batch();
    final boardRef = _firestore.boardsCollection().doc();
    final userRef = _firestore.userDoc(userID);
    try {
      // set data
      final newBoard = board.toJson();
      newBoard['id'] = boardRef.id;
      newBoard['uid'] = userID;
      newBoard['createdAt'] = Timestamp.now();

      // post data
      batch
        ..set(boardRef, newBoard)
        ..update(userRef, {
          'boards': FieldValue.arrayUnion([boardRef.id]),
        });

      // commit
      await batch.commit();

      // return doc ID
      return boardRef.id;
    } on FirebaseException {
      throw BoardFailure.fromCreateBoard();
    }
  }
}

extension Fetch on BoardRepository {
  // get board saves
  Future<int> fetchSaves(String boardID) async {
    try {
      // get document from database
      final doc = await _firestore.getBoardDoc(boardID);
      if (doc.exists) {
        // return likes
        final data = Board.fromJson(doc.data()!);
        return data.saves;
      } else {
        return 0;
      }
    } on FirebaseException {
      // return failure
      throw BoardFailure.fromGetBoard();
    }
  }

  Future<bool> hasUserSavedPost(String boardID, String userID) async {
    final savesDoc = await _firestore.getSavesDoc('${boardID}_$userID');
    return savesDoc.exists;
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

  // stream user boards
  Stream<List<Board>> streamUserBoards(
    String userID, {
    int pageSize = 10,
    int page = 0,
  }) async* {
    final userDoc = await _firestore.getUserDoc(userID);

    if (!userDoc.exists) {
      yield [];
      return;
    }

    final userData = userDoc.data()!;

    final boardIDs = List<String>.from(
      (userData['boards'] as List).map((post) => post as String),
    );

    final reversedBoardIDs = boardIDs.reversed.toList();

    final buffer = <Board>[];
    final startIndex = page * pageSize;

    if (startIndex >= reversedBoardIDs.length) {
      yield buffer;
      return;
    }

    final boardIDsPage =
        reversedBoardIDs.skip(startIndex).take(pageSize).toList();
    final boardDocs =
        await Future.wait(boardIDsPage.map(_firestore.getBoardDoc));
    final boards = boardDocs
        .map((doc) {
          if (doc.exists) {
            return Board.fromFirestore(doc);
          } else {
            return null;
          }
        })
        .whereType<Board>()
        .toList();

    buffer.addAll(boards);

    yield buffer;
  }
}

extension Update on BoardRepository {
  // update specific user field
  Future<void> updateField(String boardID, Map<String, dynamic> data) async {
    try {
      await _firestore.updateBoardDoc(boardID, data);
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

  // update liked posts
  Future<int> updateSaves({
    required String userID,
    required String boardID,
    required bool isLiked,
  }) async {
    // get document reference
    final boardRef = _firestore.postDoc(boardID);

    // user batch to perform atomic operation
    final batch = _firestore.batch();

    try {
      // get document data
      final boardSnapshot = await boardRef.get();

      // make sure board exists
      if (!boardSnapshot.exists) throw BoardFailure.fromUpdateBoard();

      if (!isLiked) {
        batch.update(boardRef, {
          'saves': FieldValue.increment(1),
        });
        // Add the new entry to the saves collection
        await _firestore.setSavesDoc('${boardID}_$userID', {
          'boardID': boardID,
          'userID': userID,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        batch.update(boardRef, {
          'saves': FieldValue.increment(-1),
        });
        await _firestore.savesDoc('${boardID}_$userID').delete();
      }
      // commit changes
      try {
        await batch.commit();
      } catch (e) {
        // something failed with batch.commit().
        // the batch was rolled back.
        print('could not commit changes $e');
      }
      return fetchSaves(boardID);
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

      await _firestore.processQueryInBatches(boardsQuery, batch, (boardDoc) {
        batch.update(boardDoc.reference, {
          'boards': FieldValue.arrayRemove([boardID]),
        });
      });

      // find all users who liked this post
      var usersQuery = _firestore
          .collection('users')
          .where('savedBoards', arrayContains: boardID)
          .limit(batchSize);

      await _firestore.processQueryInBatches(usersQuery, batch, (userDoc) {
        batch.update(userDoc.reference, {
          'savedBoards': FieldValue.arrayRemove([boardID]),
        });
      });

      // find all users who liked this post
      usersQuery = _firestore
          .collection('users')
          .where('boards', arrayContains: boardID)
          .limit(batchSize);

      await _firestore.processQueryInBatches(usersQuery, batch, (userDoc) {
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
