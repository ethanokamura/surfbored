import 'dart:io';
import 'package:api_client/api_client.dart';
import 'package:board_repository/board_repository.dart';
import 'package:user_repository/user_repository.dart';

class BoardRepository {
  BoardRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  // upload image
  Future<String?> uploadImage(
    File file,
    String doc,
  ) async {
    try {
      // upload to firebase
      final url =
          await _storage.uploadFile('boards/$doc/cover_image.jpeg', file);
      // save photoURL to document
      await _firestore.updateBoardDoc(doc, {'photoURL': url});
      return url;
    } catch (e) {
      return null;
    }
  }

  // check if user has liked an post
  Future<bool> hasPost(String boardID, String postID) async {
    try {
      // get document from database
      final doc = await _firestore.getBoardDoc(boardID);
      if (doc.exists) {
        // return board
        final boardData = Board.fromJson(doc.data()!);
        return boardData.hasPost(postID: postID);
      }
      return false;
    } on FirebaseException {
      throw UserFailure.fromGetUser();
    }
  }
}

extension Create on BoardRepository {
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
        final newBoard = board.toJson();
        newBoard['id'] = boardRef.id;
        newBoard['uid'] = userID;
        newBoard['createdAt'] = Timestamp.now();

        // preform writes
        transaction.set(boardRef, newBoard);

        // return id
        return boardRef.id;
      });
    } on FirebaseException {
      throw BoardFailure.fromCreateBoard();
    }
  }
}

extension Read on BoardRepository {
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

  // get board posts
  Future<List<String>> readPosts(String boardID) async {
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

  // stream board posts
  Stream<List<String>> readPostsStream(String boardID) {
    try {
      return _firestore.boardDoc(boardID).snapshots().map((snapshot) {
        if (snapshot.exists) {
          final data = Board.fromJson(snapshot.data()!);
          return data.posts;
        } else {
          throw Exception('board not found');
        }
      });
    } on FirebaseException {
      throw BoardFailure.fromGetBoard();
    }
  }

  // // check included posts
  // Future<bool> boardIncludesPost(String boardID, String postID) async {
  //   try {
  //     // get board data
  //     final doc = await _firestore.getBoardDoc(boardID);
  //     if (!doc.exists) return false;
  //     final data = Board.fromJson(doc.data()!);
  //     // check if the board contains post
  //     return data.posts.contains(postID);
  //   } on FirebaseException {
  //     // return failure
  //     throw BoardFailure.fromGetBoard();
  //   }
  // }
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

  // update liked posts
  // using batch to handle updating user, post, and board docs at the same time
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

      // update post documents based on isLiked value
      if (isLiked) {
        // update post doc
        batch.update(boardRef, {
          'savedBy': FieldValue.arrayUnion([userID]),
          'saves': FieldValue.increment(1),
        });
        // update user doc
        if (!user.boards.contains(boardID)) user.boards.add(boardID);
      } else {
        // update post doc
        batch.update(boardRef, {
          'savedBy': FieldValue.arrayRemove([userID]),
          'saves': FieldValue.increment(-1),
        });
        // update user doc
        user.boards.remove(boardID);
      }
      // batch update
      batch.update(userRef, {'likedPosts': user.boards});

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
      if (photoURL.isNotEmpty) {
        await _storage.deleteFile('boards/$boardID/cover_image.jpeg');
      }

      // delete post ref
      batch.delete(boardRef);

      // find all users that contain the board
      final boardsSnapshot = await _firestore
          .usersCollection()
          .where('boards', arrayContains: boardID)
          .get();

      // remove post reference from each board
      for (final userDoc in boardsSnapshot.docs) {
        // get liked board's posts or init if does not exist
        final userBoards = await BoardRepository().readPosts(userDoc.id);
        userBoards.remove(boardID);
        batch.update(userDoc.reference, {'boards': userBoards});
      }

      final user = await UserRepository().getUserById(userID);

      user.savedBoards.remove(boardID);
      user.boards.remove(boardID);

      batch.update(userRef, {
        'boards': user.boards,
        'likedBoards': user.savedBoards,
      });

      // commit changes
      await batch.commit();
    } on FirebaseException {
      throw BoardFailure.fromDeleteBoard();
    }
  }
}
