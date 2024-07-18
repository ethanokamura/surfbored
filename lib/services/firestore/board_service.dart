// dart packages
import 'dart:async';

// utils
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rando/services/firestore/firestore.dart';
import 'package:rando/services/models.dart';

// Firestore BoardData Service Provider
class BoardService extends FirestoreService {
  BoardService() : super();

  // create board
  Future<String> createBoard(BoardData board) async {
    try {
      // make sure user exists
      var user = auth.user;
      if (user == null) throw Exception("User not authenticated.");

      // get references
      var userRef = db.collection('users').doc(user.uid);
      var boardRef = db.collection('boards').doc();

      // add to list of boards
      return await db.runTransaction((transaction) async {
        // perform reads first
        var userSnapshot = await transaction.get(userRef);

        // make sure user exists:
        if (!userSnapshot.exists) throw Exception("User does not exist");

        // prepare data for the new board
        var newBoardData = board.toJson();
        newBoardData['id'] = boardRef.id;
        newBoardData['uid'] = user.uid;

        // preform writes
        transaction.set(boardRef, newBoardData);

        // update user's board list
        List<String> boards = List.from(userSnapshot.data()?['boards'] ?? []);
        boards.add(boardRef.id);
        transaction.update(userRef, {'boards': boards});

        // return id
        return boardRef.id;
      });
    } catch (e) {
      logger.e("error creating board: $e");
      rethrow;
    }
  }

  // get board document data from firestore as BoardData
  Future<BoardData> readBoard(String board) async {
    // get reference to the board
    var ref = db.collection('boards').doc(board);
    // get data from firestore
    var snapshot = await ref.get();
    // return json map
    return BoardData.fromJson(snapshot.data() ?? {});
  }

  // get stream of BoardData for a given board
  Stream<BoardData> getBoardStream(String boardID) {
    return db.collection('boards').doc(boardID).snapshots().map((doc) {
      return BoardData.fromJson(doc.data()!);
    });
  }

  // get stream of items for a given board
  Stream<List<ItemData>> readBoardItemStream(String boardID) {
    var boardRef = db.collection('boards').doc(boardID);
    return boardRef.snapshots().asyncMap((boardSnapshot) async {
      List<String> itemIDs = List.from(boardSnapshot.data()?['items'] ?? []);
      var itemRefs =
          itemIDs.map((id) => db.collection('items').doc(id)).toList();
      var itemSnapshots = await Future.wait(itemRefs.map((ref) => ref.get()));
      return itemSnapshots
          .map((snapshot) => ItemData.fromFirestore(snapshot))
          .toList();
    });
  }

  // get a list of all the items in a board
  Future<List<String>> getBoardItemsID(String boardID) async {
    var ref = db.collection('boards').doc(boardID);
    var snapshot = await ref.get();
    return List.from(snapshot.data()?['items'] ?? []);
  }

  /// [deprecated] ///
  // get a stream of all boards that exist in firestore
  Stream<List<BoardData>> getAllBoardStream() {
    return db.collection('boards').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => BoardData.fromFirestore(doc)).toList();
    });
  }

  // update board
  Future<void> updateBoard(String userID, BoardData board) async {
    try {
      // get firestore reference
      var ref = db.collection('boards').doc(board.id);
      // check ownership
      if (board.uid == auth.user?.uid) {
        // update firestore doc
        await ref.update(board.toJson());
      } else {
        throw Exception("Unauthorized update attempt.");
      }
    } catch (e) {
      throw Exception("board not found: $e");
    }
  }

  Future<void> updateBoardLikes(
    String userID,
    String board,
    bool isLiked,
  ) async {
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
      var userData = userSnapshot.data() as Map<String, dynamic>;
      List<String> userLikedBoards = List.from(userData['likedBoards'] ?? []);

      // update documents
      if (isLiked) {
        // update board doc
        batch.update(boardRef, {
          'likedBy': FieldValue.arrayUnion([userID]),
          'likes': FieldValue.increment(1),
        });
        // make changes to user doc
        if (!userLikedBoards.contains(board)) userLikedBoards.add(board);
      } else {
        // update board doc
        batch.update(boardRef, {
          'likedBy': FieldValue.arrayRemove([userID]),
          'likes': FieldValue.increment(-1),
        });
        // make changes to user doc
        userLikedBoards.remove(board);
      }

      // update user doc
      batch.update(userRef, {'likedBoards': userLikedBoards});

      // post changes
      await batch.commit();
    } catch (e) {
      logger.e("error updating board likes: $e");
    }
  }

  // delete board:
  Future<void> deleteBoard(String userID, String boardID, String imgURL) async {
    // reference to the user
    var userRef = db.collection('users').doc(userID);
    // reference to the board
    var boardRef = db.collection('boards').doc(boardID);
    try {
      WriteBatch batch = db.batch();

      // get data
      DocumentSnapshot userSnapshot = await userRef.get();
      DocumentSnapshot boardSnapshot = await boardRef.get();

      // throw errors
      if (!userSnapshot.exists) throw Exception("User does not exists!");
      if (!boardSnapshot.exists) throw Exception("Board does not exists!");

      // delete image
      if (imgURL.isNotEmpty) await storage.deleteFile(imgURL);

      // delete board ref
      batch.delete(boardRef);

      // get user data
      var userData = userSnapshot.data() as Map<String, dynamic>;

      /// [TODO]
      /// query all users who have liked the board
      /// remove the board from likedBoards

      // update user's liked boards
      List<String> likedBoards = List.from(userData['likedBoards'] ?? []);
      likedBoards.remove(boardID);

      // update user's items list
      List<String> boards = List.from(userData['boards'] ?? []);
      boards.remove(boardID);

      // update user doc
      batch.update(userRef, {'items': boards, 'likedBoards': likedBoards});

      // commit changes
      batch.commit();
    } catch (e) {
      throw Exception("error deleting board: $e");
    }
  }

  // check to see if a board includes an item
  Future<bool> boardIncludesItem(String boardID, String itemID) async {
    try {
      var ref = db.collection('boards').doc(boardID);
      var snapshot = await ref.get();
      if (!snapshot.exists) return false;

      var data = BoardData.fromFirestore(snapshot);
      return data.items.contains(itemID);
    } catch (e) {
      logger.e("error checking included items: $e");
      return false;
    }
  }

  // add item to board!
  Future<void> updateBoardItems(
    String boardID,
    String itemID,
    bool isSelected,
  ) async {
    // reference to the board collection
    DocumentReference ref = db.collection('boards').doc(boardID);
    try {
      // update based on if the board is selected
      await ref.update({
        'items': isSelected
            ? FieldValue.arrayUnion([itemID])
            : FieldValue.arrayRemove([itemID])
      });
    } catch (e) {
      logger.e("error updating board selection: $e");
    }
  }
}
