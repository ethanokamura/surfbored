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
      final newBoard = board.toJson()
        ..addAll({
          'id': boardRef.id,
          'uid': userID,
          'createdAt': Timestamp.now(),
        });
      batch
        ..set(boardRef, newBoard)
        ..update(userRef, {
          'boards': FieldValue.arrayUnion([boardRef.id]),
        });
      await batch.commit();
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
      final doc = await _firestore.getBoardDoc(boardID);
      if (!doc.exists) return 0;
      final data = Board.fromJson(doc.data()!);
      return data.saves;
    } on FirebaseException {
      throw BoardFailure.fromGetBoard();
    }
  }

  Future<bool> hasUserSavedPost(String boardID, String userID) async {
    try {
      final savesDoc = await _firestore.getSavesDoc('${boardID}_$userID');
      return savesDoc.exists;
    } on FirebaseException {
      throw BoardFailure.fromGetBoard();
    }
  }
}

extension StreamData on BoardRepository {
  // stream board data
  Stream<Board> streamBoard(String boardID) {
    try {
      return _firestore.boardDoc(boardID).snapshots().map((snapshot) {
        if (snapshot.exists) return Board.fromJson(snapshot.data()!);
        throw BoardFailure.fromGetBoard();
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

    final boardIDs = List<String>.from(
      (userDoc.data()!['boards'] as List).map((board) => board as String),
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
    final boardDocs = await _firestore
        .boardsCollection()
        .where(FieldPath.documentId, whereIn: boardIDsPage)
        .get();

    // Process documents and add to buffer
    for (final doc in boardDocs.docs) {
      buffer.add(Board.fromFirestore(doc));
    }

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
  Future<void> updateSaves({
    required String userID,
    required String boardID,
    required bool isLiked,
  }) async {
    final boardRef = _firestore.postDoc(boardID);
    final saveRef = _firestore.savesDoc('${boardID}_$userID');
    final batch = _firestore.batch();

    try {
      if (!isLiked) {
        batch
          ..update(boardRef, {'saves': FieldValue.increment(1)})
          ..set(saveRef, {
            'boardID': boardID,
            'userID': userID,
            'timestamp': FieldValue.serverTimestamp(),
          });
      } else {
        batch
          ..update(boardRef, {
            'saves': FieldValue.increment(-1),
          })
          ..delete(saveRef);
      }
      // commit changes
      await batch.commit();
    } on FirebaseException {
      throw BoardFailure.fromUpdateBoard();
    }
  }
}

extension Delete on BoardRepository {
  // delete board:
  Future<void> deleteBoard(
      String userID, String boardID, String photoURL,) async {
    final batch = _firestore.batch();
    final boardRef = _firestore.boardDoc(boardID);
    final saveRef = _firestore.savesDoc(boardID);
    const batchSize = 500;
    try {
      final boardDoc = await boardRef.get();
      if (!boardDoc.exists) {
        throw BoardFailure.fromGetBoard();
      }

      batch
        ..delete(boardRef)
        ..delete(saveRef)
        ..update(_firestore.userDoc(userID), {
          'boards': FieldValue.arrayRemove([boardID]),
        });

      // find all boards containing this post
      final boardsQuery = _firestore
          .savesCollection()
          .where('boardID', arrayContains: boardID)
          .limit(batchSize);

      // delete all docs
      await _firestore.deleteDocumentsByQuery(boardsQuery, batch);

      // Optionally delete the associated image file
      if (photoURL.isNotEmpty) {
        await _storage.refFromURL(photoURL).delete();
      }

      await batch.commit();
    } on FirebaseException {
      throw BoardFailure.fromDeleteBoard();
    }
  }
}
