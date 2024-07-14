// dart packages
import 'dart:async';

// utils
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:rando/services/storage.dart';
import 'package:rando/services/auth.dart';
import 'package:rando/services/models.dart';

class ItemService {
  // firestore database
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final StorageService storage = StorageService();
  final AuthService auth = AuthService();
  final Logger logger = Logger();

  // Set user's item's photo URL path
  Future<void> setItemPhotoURL(String itemID, String filepath) async {
    var ref = db.collection('items').doc(itemID);
    // save photoURL in user doc
    await ref.set({'imgURL': filepath}, SetOptions(merge: true));
  }

  /// Create [Item]:
  Future<String> createItem(ItemData item) async {
    try {
      // make sure user exists
      var user = auth.user;
      if (user == null) throw Exception("User not authenticated.");

      // get references
      var userRef = db.collection('users').doc(user.uid);
      var itemRef = db.collection('items');

      // add to list of items
      return await db.runTransaction((transaction) async {
        // perform reads first
        var userSnapshot = await transaction.get(userRef);

        // make sure user exists:
        if (!userSnapshot.exists) throw Exception("User does not exist");

        // prepare data for the new item
        var docRef = itemRef.doc();
        var newItemData = item.toJson();
        newItemData['id'] = docRef.id;
        newItemData['uid'] = user.uid;

        // preform writes
        transaction.set(docRef, newItemData);

        // update user's item list
        List<String> items = List.from(userSnapshot.data()?['items'] ?? []);
        items.add(docRef.id);
        transaction.update(userRef, {'items': items});

        // return id
        return docRef.id;
      });
    } catch (e) {
      logger.e("error creating item: $e");
      rethrow;
    }
  }

  /// Read [Item]:
  Future<ItemData> readItem(String userID, String itemID) async {
    // get reference to the item
    var ref =
        db.collection('users').doc(userID).collection('items').doc(itemID);
    var snapshot = await ref.get();
    // return json map
    return ItemData.fromJson(snapshot.data() ?? {});
  }

  /// Read List of [Item]s:
  Stream<ItemData> getItemStream(String itemID) {
    return db
        .collection('items')
        .doc(itemID)
        .snapshots()
        .map((doc) => ItemData.fromJson(doc.data()!));
  }

  Stream<List<ItemData>> getAllItemStream() {
    return db.collection('items').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ItemData.fromFirestore(doc)).toList();
    });
  }

  /// Update [Item]:
  Future<void> updateItem(String userID, ItemData item) async {
    try {
      var ref = db.collection('items').doc(item.id);
      if (item.uid == auth.user?.uid) {
        var data = item.toJson();
        await ref.update(data);
      } else {
        throw Exception("Unauthorized update attempt.");
      }
    } catch (e) {
      throw Exception("item not found: $e");
    }
  }

  Future<void> updateItemLikes(
      String userID, String itemID, bool isLiked) async {
    DocumentReference userRef = db.collection('users').doc(userID);
    DocumentReference itemRef = db.collection('items').doc(itemID);

    try {
      // user batch to perform atomic operations
      WriteBatch batch = db.batch();

      // get docs
      DocumentSnapshot userSnapshot = await userRef.get();
      DocumentSnapshot itemSnapshot = await itemRef.get();

      // throw errors
      if (!userSnapshot.exists) throw Exception("User does not exists!");
      if (!itemSnapshot.exists) throw Exception("Item does not exists!");

      // get user's liked items or init if does not exist
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      List<String> userLikedItems = userData.containsKey('likedItems')
          ? List.from(userData['likedItems'])
          : [];

      // update documents
      if (isLiked) {
        batch.update(itemRef, {
          'likedBy': FieldValue.arrayUnion([userID]),
          'likes': FieldValue.increment(1),
        });
        if (!userLikedItems.contains(itemID)) userLikedItems.add(itemID);
      } else {
        batch.update(itemRef, {
          'likedBy': FieldValue.arrayRemove([userID]),
          'likes': FieldValue.increment(-1),
        });
        if (userLikedItems.contains(itemID)) userLikedItems.remove(itemID);
      }
      batch.update(userRef, {'likedItems': userLikedItems});

      // post changes
      await batch.commit();
    } catch (e) {
      logger.e("error updating item likes: $e");
    }
  }

  /// Delete [Item]:
  Future<void> deleteItem(String userID, String itemID, String imgPath) async {
    try {
      // reference to the item
      var userRef = db.collection('users').doc(userID);
      var itemRef = db.collection('items').doc(itemID);
      await db.runTransaction((transaction) async {
        // check if the user is the owner of the item
        var itemSnapshot = await transaction.get(itemRef);
        if (!itemSnapshot.exists || itemSnapshot.data()?['uid'] != userID) {
          throw Exception("Unauthorized delete attempt.");
        }
        // delete photo
        storage.deleteFile(imgPath);
        // remove item from 'items collection'
        transaction.delete(itemRef);
        // update user's item list
        var userSnapshot = await transaction.get(userRef);
        List<String> items = List.from(userSnapshot.data()?['items'] ?? []);
        items.remove(itemID);
        transaction.update(userRef, {'items': items});
      });
    } catch (e) {
      throw Exception("error deleting item: $e");
    }
  }
}
