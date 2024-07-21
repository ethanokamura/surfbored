// dart packages
import 'dart:async';

// utils
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rando/core/services/firestore.dart';
import 'package:rando/core/models/models.dart';

// Firestore ItemData Service Provider
class ItemService extends FirestoreService {
  ItemService() : super();

  // create item
  Future<String> createItem(ItemData item) async {
    try {
      // make sure user exists
      var user = auth.user;
      if (user == null) throw Exception("User not authenticated.");

      // get references
      var userRef = db.collection('users').doc(user.uid);
      var itemRef = db.collection('items').doc();

      // add to list of items
      return await db.runTransaction((transaction) async {
        // perform reads first
        var userSnapshot = await transaction.get(userRef);

        // make sure user exists:
        if (!userSnapshot.exists) throw Exception("User does not exist");

        // prepare data for the new item
        var newItemData = item.toJson();
        newItemData['id'] = itemRef.id;
        newItemData['uid'] = user.uid;

        // preform writes
        transaction.set(itemRef, newItemData);

        // update user's item list
        List<String> items = List.from(userSnapshot.data()?['items'] ?? []);
        items.add(itemRef.id);
        transaction.update(userRef, {'items': items});

        // return id
        return itemRef.id;
      });
    } catch (e) {
      logger.e("error creating item: $e");
      rethrow;
    }
  }

  // get item document data from firestore as ItemData
  Future<ItemData> readItem(String itemID) async {
    // get reference to the item
    var ref = db.collection('items').doc(itemID);
    // get data from firestore
    var snapshot = await ref.get();
    // return json map
    return ItemData.fromJson(snapshot.data() ?? {});
  }

  // get stream of ItemData for a given item
  Stream<ItemData> getItemStream(String itemID) {
    return db.collection('items').doc(itemID).snapshots().map((doc) {
      return ItemData.fromJson(doc.data()!);
    });
  }

  /// [deprecated] ///
  // get a stream of all items that exist in firestore
  Stream<List<ItemData>> getAllItemStream() {
    return db.collection('items').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ItemData.fromFirestore(doc)).toList();
    });
  }

  // update item
  Future<void> updateItem(String userID, ItemData item) async {
    try {
      // get firestore reference
      var ref = db.collection('items').doc(item.id);
      // check ownership
      if (item.uid == auth.user?.uid) {
        // update firestore doc
        await ref.update(item.toJson());
      } else {
        throw Exception("Unauthorized update attempt.");
      }
    } catch (e) {
      throw Exception("item not found: $e");
    }
  }

  // update liked items
  // using batch to handle updating user, item, and board docs at the same time
  Future<void> updateItemLikes(
    String userID,
    String itemID,
    String boardID,
    bool isLiked,
  ) async {
    try {
      // get document references
      DocumentReference userRef = db.collection('users').doc(userID);
      DocumentReference itemRef = db.collection('items').doc(itemID);
      DocumentReference boardRef = db.collection('boards').doc(boardID);

      // user batch to perform atomic operations
      WriteBatch batch = db.batch();

      // get document data
      DocumentSnapshot userSnapshot = await userRef.get();
      DocumentSnapshot itemSnapshot = await itemRef.get();
      DocumentSnapshot boardSnapshot = await boardRef.get();

      // throw errors
      if (!userSnapshot.exists) throw Exception("User does not exists!");
      if (!itemSnapshot.exists) throw Exception("Item does not exists!");
      if (!boardSnapshot.exists) throw Exception("Board does not exists!");

      // get user's liked items or init if does not exist
      var userData = userSnapshot.data() as Map<String, dynamic>;
      List<String> userLikedItems = List.from(userData['likedItems'] ?? []);

      // get liked board's items or init if does not exist
      var boardData = boardSnapshot.data() as Map<String, dynamic>;
      List<String> likedBoardItems = List.from(boardData['items'] ?? []);

      // update item documents based on isLiked value
      if (isLiked) {
        // update item doc
        batch.update(itemRef, {
          'likedBy': FieldValue.arrayUnion([userID]),
          'likes': FieldValue.increment(1),
        });
        // update user doc
        if (!userLikedItems.contains(itemID)) userLikedItems.add(itemID);
        // update board doc
        if (!likedBoardItems.contains(itemID)) likedBoardItems.add(itemID);
      } else {
        // update item doc
        batch.update(itemRef, {
          'likedBy': FieldValue.arrayRemove([userID]),
          'likes': FieldValue.increment(-1),
        });
        // update user doc
        userLikedItems.remove(itemID);
        // update board doc
        likedBoardItems.remove(itemID);
      }
      // batch update
      batch.update(userRef, {'likedItems': userLikedItems});
      batch.update(boardRef, {'items': likedBoardItems});

      // commit changes
      await batch.commit();
    } catch (e) {
      logger.e("error updating item likes: $e");
    }
  }

  // delete item:
  // we need to delete the item at all reference points
  Future<void> deleteItem(String userID, String itemID, String imgPath) async {
    // reference to the user
    var userRef = db.collection('users').doc(userID);
    // reference to the item
    var itemRef = db.collection('items').doc(itemID);
    try {
      WriteBatch batch = db.batch();
      DocumentSnapshot userSnapshot = await userRef.get();
      DocumentSnapshot itemSnapshot = await itemRef.get();

      // throw errors
      if (!userSnapshot.exists) throw Exception("User does not exists!");
      if (!itemSnapshot.exists) throw Exception("Board does not exists!");

      // delete image
      if (imgPath.isNotEmpty) await storage.deleteFile(imgPath);

      // delete item ref
      batch.delete(itemRef);

      // find all boards that contain the item
      QuerySnapshot boardsSnapshot = await db
          .collection('boards')
          .where('items', arrayContains: itemID)
          .get();

      // remove item reference from each board
      for (QueryDocumentSnapshot boardDoc in boardsSnapshot.docs) {
        Map<String, dynamic> boardData =
            boardDoc.data() as Map<String, dynamic>;
        List<String> boardItems = List<String>.from(boardData['items'] ?? []);
        boardItems.remove(itemID);
        batch.update(boardDoc.reference, {'items': boardItems});
      }

      // update user's liked items list
      var userData = userSnapshot.data() as Map<String, dynamic>;
      List<String> likedItems = List.from(userData['likedItems'] ?? []);
      likedItems.remove(itemID);

      // update user's items list
      List<String> items = List.from(userData['items'] ?? []);
      items.remove(itemID);

      // update user doc
      batch.update(userRef, {'items': items, 'likedItems': likedItems});

      // commit changes
      batch.commit();
    } catch (e) {
      throw Exception("error deleting item: $e");
    }
  }
}
