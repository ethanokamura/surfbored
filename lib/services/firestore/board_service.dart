// dart packages
import 'dart:async';

// utils
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:rando/services/storage.dart';
import 'package:rando/services/auth.dart';
import 'package:rando/services/models.dart';

class BoardService {
  // firestore database
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final StorageService storage = StorageService();
  final AuthService auth = AuthService();
  final Logger logger = Logger();

  /// Create [Board]:
  Future<String> createBoard(BoardData board) async {
    try {
      // make sure user exists
      var user = auth.user;
      if (user == null) throw Exception("User not authenticated.");

      // get references
      var userRef = db.collection('users').doc(user.uid);
      var boardRef = db.collection('boards');

      // add to list of boards
      return await db.runTransaction((transaction) async {
        // perform reads first
        var userSnapshot = await transaction.get(userRef);

        // make sure user exists:
        if (!userSnapshot.exists) throw Exception("User does not exist");

        // prepare data for the new board
        var docRef = boardRef.doc();
        var newBoardData = board.toJson();
        newBoardData['id'] = docRef.id;
        newBoardData['uid'] = user.uid;

        // preform writes
        transaction.set(docRef, newBoardData);

        // update user's board list
        List<String> boards = List.from(userSnapshot.data()?['boards'] ?? []);
        boards.add(docRef.id);
        transaction.update(userRef, {'boards': boards});

        // return id
        return docRef.id;
      });
    } catch (e) {
      logger.e("error creating board: $e");
      rethrow;
    }
  }

  /// Read [Board]:
  Future<BoardData> readBoard(String userID, String board) async {
    // get reference to the board
    var ref =
        db.collection('users').doc(userID).collection('boards').doc(board);
    var snapshot = await ref.get();
    // return json map
    return BoardData.fromJson(snapshot.data() ?? {});
  }

  /// Read List of [Board]s:
  Stream<BoardData> getBoardStream(String board) {
    return db
        .collection('boards')
        .doc(board)
        .snapshots()
        .map((doc) => BoardData.fromJson(doc.data()!));
  }

  Stream<List<BoardData>> getAllBoardStream() {
    return db.collection('boards').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => BoardData.fromFirestore(doc)).toList();
    });
  }

  /// Update [Board]:
  Future<void> updateBoard(String userID, BoardData board) async {
    try {
      var ref = db.collection('boards').doc(board.id);
      if (board.uid == auth.user?.uid) {
        var data = board.toJson();
        await ref.update(data);
      } else {
        throw Exception("Unauthorized update attempt.");
      }
    } catch (e) {
      throw Exception("board not found: $e");
    }
  }

  Future<void> updateBoardLikes(
      String userID, String board, bool isLiked) async {
    DocumentReference userRef = db.collection('users').doc(userID);
    DocumentReference boardRef = db.collection('boards').doc(board);

    try {
      // user batch to perform atomic operations
      WriteBatch batch = db.batch();

      // get docs
      DocumentSnapshot userSnapshot = await userRef.get();
      DocumentSnapshot boardSnapshot = await boardRef.get();

      // throw errors
      if (!userSnapshot.exists) throw Exception("User does not exists!");
      if (!boardSnapshot.exists) throw Exception("Board does not exists!");

      // get user's liked boards or init if does not exist
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      List<String> userLikedBoards = userData.containsKey('likedBoards')
          ? List.from(userData['likedBoards'])
          : [];

      // update documents
      if (isLiked) {
        batch.update(boardRef, {
          'likedBy': FieldValue.arrayUnion([userID]),
          'likes': FieldValue.increment(1),
        });
        if (!userLikedBoards.contains(board)) userLikedBoards.add(board);
      } else {
        batch.update(boardRef, {
          'likedBy': FieldValue.arrayRemove([userID]),
          'likes': FieldValue.increment(-1),
        });
        if (userLikedBoards.contains(board)) userLikedBoards.remove(board);
      }
      batch.update(userRef, {'likedBoards': userLikedBoards});

      // post changes
      await batch.commit();
    } catch (e) {
      logger.e("error updating board likes: $e");
    }
  }

  /// Delete [Board]:
  Future<void> deleteBoard(String userID, String board, String imgPath) async {
    try {
      // reference to the board
      var userRef = db.collection('users').doc(userID);
      var boardRef = db.collection('boards').doc(board);
      await db.runTransaction((transaction) async {
        // check if the user is the owner of the board
        var boardSnapshot = await transaction.get(boardRef);
        if (!boardSnapshot.exists || boardSnapshot.data()?['uid'] != userID) {
          throw Exception("Unauthorized delete attempt.");
        }
        // delete photo
        storage.deleteFile(imgPath);
        // remove board from 'boards collection'
        transaction.delete(boardRef);
        // update user's board list
        var userSnapshot = await transaction.get(userRef);
        List<String> boards = List.from(userSnapshot.data()?['boards'] ?? []);
        boards.remove(board);
        transaction.update(userRef, {'boards': boards});
      });
    } catch (e) {
      throw Exception("error deleting board: $e");
    }
  }
}
