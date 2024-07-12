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
  Future<void> setItemPhotoURL(
      String userID, String itemID, String filepath) async {
    var ref = db.collection('items').doc(itemID);
    // save photoURL in user doc
    await ref.set({'imgURL': filepath}, SetOptions(merge: true));
  }

  /// Create [Item]:
  Future<String> createItem(ItemData item) async {
    try {
      var user = auth.user;
      // make sure user is found
      if (user == null) throw Exception("User not authenticated.");

      // get references
      var userRef = db.collection('users').doc(user.uid);
      var itemRef = db.collection('items');
      // add to list of items
      return await db.runTransaction((transaction) async {
        // add item to 'items' collection
        var docRef = itemRef.doc();
        transaction.set(docRef, item.toJson());

        // update user's item list
        var userSnapshot = await transaction.get(userRef);
        List<String> items = List.from(userSnapshot.data()?['items'] ?? []);
        items.add(docRef.id);
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
  // Stream<List<ItemData>> readItemStream(String userID) {
  //   var userRef = db.collection('users').doc(userID);
  //   return userRef.snapshots().asyncMap((userSnapshot) async {
  //     List<String> itemIDs = List.from(userSnapshot.data()?['items'] ?? []);
  //     var itemRefs =
  //         itemIDs.map((id) => db.collection('items').doc(id)).toList();
  //     var itemSnapshots = await Future.wait(itemRefs.map((ref) => ref.get()));
  //     return itemSnapshots
  //         .map((snapshot) => ItemData.fromFirestore(snapshot))
  //         .toList();
  //   });
  // }

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

    await db.runTransaction((transation) async {
      // get docs
      DocumentSnapshot userSnapshot = await transation.get(userRef);
      DocumentSnapshot itemSnapshot = await transation.get(itemRef);

      // throw errors
      if (!userSnapshot.exists) throw Exception("User does not exists!");
      if (!itemSnapshot.exists) throw Exception("Item does not exists!");

      // add to liked items
      List<String> likedItems = List.from(userSnapshot['likedItems']);
      if (isLiked && !likedItems.contains(itemID)) {
        likedItems.add(itemID);
      } else if (!isLiked && likedItems.contains(itemID)) {
        likedItems.remove(itemID);
      }
      transation.update(userRef, {'likedItems': likedItems});

      // add to liked by
      List<String> likedBy = List.from(userSnapshot['likedBy']);
      if (isLiked && !likedBy.contains(userID)) {
        likedBy.add(userID);
      } else if (!isLiked && likedItems.contains(userID)) {
        likedBy.remove(userID);
      }
      transation.update(userRef, {'likedBy': likedBy});
    });
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
