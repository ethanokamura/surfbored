import 'dart:io';
import 'package:api_client/api_client.dart';
import 'package:boards_repository/src/failures.dart';
import 'package:boards_repository/src/models/models.dart';
import 'package:user_repository/user_repository.dart';

class BoardsRepository {
  BoardsRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  // upload image
  Future<String?> uploadImage(
    File file,
    String docID,
  ) async {
    try {
      // upload to firebase
      final url = await _storage.uploadFile('boards/$docID/', file);
      // save photoURL to document
      await _firestore.updateBoardDoc(docID, {'photoURL': url});
      return url;
    } catch (e) {
      return null;
    }
  }

  // create a board
  Future<String> createBoard(Board board, String userID) async {
    try {
      return await _firestore.runTransaction((transaction) async {
        // get references
        final userRef = _firestore.userDoc(userID);
        final boardRef = _firestore.collection('boards').doc();

        // get user doc
        final userSnapshot = await transaction.get(userRef);
        if (!userSnapshot.exists) throw Exception('User does not exist');

        // update user doc
        transaction.update(userRef, {
          'boards': FieldValue.arrayUnion([boardRef.id]),
        });

        // prepare data for the new board
        final newItemData = board.toJson();
        newItemData['id'] = boardRef.id;
        newItemData['uid'] = userID;

        // preform writes
        transaction.set(boardRef, newItemData);

        // return id
        return boardRef.id;
      });
    } on FirebaseException {
      throw BoardFailure.fromCreateBoard();
    }
  }

  // get board document
  Future<Board> readBoard(String boardID) async {
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

  // stream board data
  Stream<Board> readBoardStream(String boardID) {
    try {
      return _firestore.boardDoc(boardID).snapshots().map((snapshot) {
        if (snapshot.exists) {
          return Board.fromJson(snapshot.data()!);
        } else {
          throw Exception('Board not found');
        }
      });
    } on FirebaseException {
      throw BoardFailure.fromGetBoard();
    }
  }

  // get board items
  Future<List<String>> readItems(String boardID) async {
    try {
      // get document from database
      final doc = await _firestore.getBoardDoc(boardID);
      if (doc.exists) {
        // return board
        final data = Board.fromJson(doc.data()!);
        return data.items;
      } else {
        // return empty board if document DNE
        return [];
      }
    } on FirebaseException {
      // return failure
      throw BoardFailure.fromGetBoard();
    }
  }

  // stream board items
  Stream<List<String>> readBoardItemStream(String boardID) {
    try {
      return _firestore.boardDoc(boardID).snapshots().map((snapshot) {
        if (snapshot.exists) {
          final data = Board.fromJson(snapshot.data()!);
          return data.items;
        } else {
          throw Exception('board not found');
        }
      });
    } on FirebaseException {
      throw BoardFailure.fromGetBoard();
    }
  }

  // check included items
  Future<bool> boardIncludesItem(String boardID, String itemID) async {
    try {
      // get board data
      final doc = await _firestore.getBoardDoc(boardID);
      if (!doc.exists) return false;
      final data = Board.fromJson(doc.data()!);
      // check if the board contains item
      return data.items.contains(itemID);
    } on FirebaseException {
      // return failure
      throw BoardFailure.fromGetBoard();
    }
  }

  // update specific user field
  Future<void> updateField(String boardID, String field, String data) async {
    try {
      await _firestore.updateBoardDoc(boardID, {field: data});
    } on FirebaseException {
      throw BoardFailure.fromUpdateBoard();
    }
  }

  // update board items
  Future<void> updateBoardItems({
    required String boardID,
    required String itemID,
    required bool isSelected,
  }) async {
    try {
      // update based on if the board is selected
      await _firestore.updateBoardDoc(boardID, {
        'items': isSelected
            ? FieldValue.arrayUnion([itemID])
            : FieldValue.arrayRemove([itemID]),
      });
    } on FirebaseException {
      // return failure
      throw BoardFailure.fromUpdateBoard();
    }
  }

  // update liked items
  // using batch to handle updating user, item, and board docs at the same time
  Future<void> updateBoardLikes({
    required String userID,
    required String boardID,
    required bool isLiked,
  }) async {
    try {
      // get document references
      final userRef = _firestore.userDoc(userID);
      final boardRef = _firestore.boardDoc(boardID);

      // user batch to perform atomic operation
      final batch = _firestore.batch();

      // get document data
      final userSnapshot = await userRef.get();
      final boardSnapshot = await boardRef.get();

      // make sure user exists
      if (!userSnapshot.exists || !boardSnapshot.exists) {
        throw Exception('Data does not exist!');
      }

      // get user
      final user = await UserRepository().getUserById(userID);

      // update item documents based on isLiked value
      if (isLiked) {
        // update item doc
        batch.update(boardRef, {
          'likedBy': FieldValue.arrayUnion([userID]),
          'likes': FieldValue.increment(1),
        });
        // update user doc
        if (!user.boards.contains(boardID)) user.boards.add(boardID);
      } else {
        // update item doc
        batch.update(boardRef, {
          'likedBy': FieldValue.arrayRemove([userID]),
          'likes': FieldValue.increment(-1),
        });
        // update user doc
        user.boards.remove(boardID);
      }
      // batch update
      batch.update(userRef, {'likedItems': user.boards});

      // commit changes
      await batch.commit();
    } on FirebaseException {
      throw BoardFailure.fromUpdateBoard();
    }
  }

  // delete item:
  // we need to delete the item at all reference points
  Future<void> deleteBoard(
    String userID,
    String boardID,
    String photoURL,
  ) async {
    try {
      // start batch
      final batch = _firestore.batch();

      // get references
      final userRef = _firestore.userDoc(userID);
      final boardRef = _firestore.boardDoc(boardID);

      // ensure existing docs
      final userSnapshot = await userRef.get();
      final boardSnapshot = await boardRef.get();

      // throw errors
      if (!userSnapshot.exists || !boardSnapshot.exists) {
        throw Exception('Data does not exists!');
      }

      // delete image
      if (photoURL.isNotEmpty) await _storage.deleteFile(photoURL);

      // delete item ref
      batch.delete(boardRef);

      // find all users that contain the board
      final boardsSnapshot = await _firestore
          .usersCollection()
          .where('boards', arrayContains: boardID)
          .get();

      // remove item reference from each board
      for (final userDoc in boardsSnapshot.docs) {
        // get liked board's items or init if does not exist
        final userBoards = await BoardsRepository().readItems(userDoc.id);
        userBoards.remove(boardID);
        batch.update(userDoc.reference, {'boards': userBoards});
      }

      final user = await UserRepository().getUserById(userID);

      user.likedBoards.remove(boardID);
      user.boards.remove(boardID);

      batch.update(userRef, {
        'boards': user.boards,
        'likedBoards': user.likedBoards,
      });

      // commit changes
      await batch.commit();
    } on FirebaseException {
      throw BoardFailure.fromDeleteBoard();
    }
  }
}
