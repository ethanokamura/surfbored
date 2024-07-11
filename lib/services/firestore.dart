// dart packages
import 'dart:async';

// utils
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rando/services/auth.dart';
import 'package:rando/services/models.dart';

class FirestoreService {
  // firestore database
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final AuthService auth = AuthService();
  final Logger logger = Logger();

  // Check if Username is Unique
  Future<bool> isUsernameUnique(String username) async {
    var querySnapshot = await db
        .collection('usernames')
        .where('username', isEqualTo: username)
        .get();
    return querySnapshot.docs.isEmpty;
  }

  // Save Username
  Future<void> saveUsername(String username) async {
    var user = auth.user!;
    var userRef = db.collection('users').doc(user.uid);

    // save the username in a separate collection for quick lookup
    await db.collection('usernames').doc(user.uid).set({
      'username': username,
      'uid': user.uid,
    });

    // save username in user doc
    await userRef.set({
      'username': username,
    }, SetOptions(merge: true));
  }

  // Check if the current user has a username
  Future<bool> userHasUsername() async {
    var user = auth.user!;
    var userDoc = await db.collection('users').doc(user.uid).get();
    return userDoc.exists && userDoc.data()!.containsKey('username');
  }

  // Read a Single List of Items:
  Future<UserData> getUserData(String userID) async {
    // get a reference of that item
    var ref = db.collection('users').doc(userID);
    // get snapshot
    var snapshot = await ref.get();
    if (snapshot.exists) {
      return UserData();
    }
    // convert to note model from model.dart
    return UserData.fromJson(snapshot.data() ?? {});
  }

  // Read a Single List of Items:
  Stream<UserData> getUserStream() {
    return auth.userStream.switchMap((user) {
      if (user != null) {
        var ref = db.collection('users').doc(user.uid);
        return ref.snapshots().map((doc) => UserData.fromJson(doc.data()!));
      } else {
        return Stream.fromIterable([UserData()]);
      }
    });
  }

  // Set user's photo URL path
  Future<void> setUserPhotoURL(String userID, String filename) async {
    var userRef = db.collection('users').doc(userID);
    // save profilePicturePath in user doc
    await userRef.set(
      {'imgURL': 'users/$userID/$filename'},
      SetOptions(merge: true),
    );
  }

  // Set user's item's photo URL path
  Future<void> setItemPhotoURL(
      String userID, String itemID, String filepath) async {
    var userRef =
        db.collection('users').doc(userID).collection('items').doc(itemID);
    // save photoURL in user doc
    await userRef.set({'imgURL': filepath}, SetOptions(merge: true));
  }

  /// Create [Item]:
  Future<String> createItem(ItemData item) async {
    try {
      var user = auth.user;
      // make sure user is found
      if (user == null) throw Exception("User not authenticated.");
      // get collection reference
      var ref = db.collection('users').doc(auth.user!.uid).collection('items');
      // add to list of items
      var docRef = await ref.add(item.toJson());
      // add the id to the item's id field
      ref.doc(docRef.id).update({'id': docRef.id});
      // return the item's id!
      return docRef.id;
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
  Stream<List<ItemData>> readItemStream(String userID) {
    var ref = db.collection('users').doc(userID).collection('items');
    return ref.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ItemData.fromFirestore(doc)).toList());
  }

  /// Update [Item]:
  Future<void> updateItem(String userID, ItemData item) async {
    try {
      var ref =
          db.collection('users').doc(userID).collection('items').doc(item.id);
      var data = item.toJson();
      await ref.update(data);
    } catch (e) {
      throw Exception("item not found: $e");
    }
  }

  /// Delete [Item]:
  Future<void> deleteItem(BoardData list, String itemID) async {
    try {
      // reference to the item
      var ref =
          db.collection('users').doc(list.uid).collection('items').doc(itemID);
      return ref.delete();
      // must delete the image from storage bucket as well...
    } catch (e) {
      throw Exception("error deleting item: $e");
    }
  }

  // /// THIS IS THE END OF THE NEW VERSION OF FIRESTORE
  // /// ANYTHING BEYOND THIS POINT IS OLD AND MUST BE UPDATED
  // /// [DO NOT CROSS THIS LINE]

  // // Create List:
  // Future<void> addList(Board list) async {
  //   // grab current user
  //   var user = auth.user!;
  //   var ref = db.collection('users').doc(user.uid).collection('lists');
  //   // add to list
  //   await ref.add(list.toJson());
  // }

  // // Read List Stream
  // Stream<List<Board>> getListStream() {
  //   var user = auth.user!;
  //   var ref = db.collection('users').doc(user.uid).collection('lists');
  //   return ref.snapshots().map((snapshot) =>
  //       snapshot.docs.map((doc) => Board.fromFirestore(doc)).toList());
  // }

  // // Read a Single List:
  // Future<Board> getList(String listID) async {
  //   try {
  //     // grab current user
  //     var user = auth.user!;

  //     // get a reference of that item
  //     var ref =
  //         db.collection('users').doc(user.uid).collection('lists').doc(listID);
  //     // get snapshot
  //     var snapshot = await ref.get();
  //     // check if document exists and convert data to ItemList
  //     if (snapshot.exists) {
  //       var itemList = Board.fromJson(snapshot.data()!);
  //       return itemList;
  //     } else {
  //       throw Exception('ItemList not found with ID: $listID');
  //     }
  //   } catch (e) {
  //     // handle errors, e.g., log the error or throw a custom exception
  //     print('Error fetching ItemList: $e');
  //     rethrow; // rethrow the exception to propagate it further
  //   }
  // }

  // // Update List:
  // Future<void> updateList(Board list, String listID) async {
  //   try {
  //     var ref =
  //         db.collection('users').doc(list.uid).collection('lists').doc(listID);
  //     var data = list.toJson();
  //     await ref.update(data);
  //   } catch (e) {
  //     throw Exception("list not found: $e");
  //   }
  // }

  // // Delete List:
  // Future<void> deleteList(String listID) {
  //   // grab current user
  //   var user = auth.user!;

  //   var ref =
  //       db.collection('users').doc(user.uid).collection('lists').doc(listID);
  //   return ref.delete();
  // }

  // // Create Item:
  // Future<void> addItem(String title, String description, String listID) async {
  //   Item newItem = Item(title: title, description: description);
  //   await FirestoreService().addItemToList(newItem, listID);
  // }

  // // Add Item:
  // Future<void> addItemToList(Item item, String listID) async {
  //   // grab current user
  //   var user = auth.user!;

  //   var listRef =
  //       db.collection('users').doc(user.uid).collection('lists').doc(listID);

  //   var itemRef = listRef.collection('items');
  //   var data = {
  //     'id': item.id,
  //     'title': item.title,
  //     'description': item.description,
  //   };

  //   // get the current list document
  //   DocumentSnapshot listDoc = await listRef.get();
  //   if (listDoc.exists) {
  //     Board itemList = Board.fromFirestore(listDoc);
  //     // add the new item to the list of items
  //     List<Item> updatedItems = [...itemList.items, item];
  //     // update the document
  //     await listRef.update({
  //       'items': updatedItems.map((item) => item.toJson()).toList(),
  //     });
  //     await itemRef.add(data);
  //   } else {
  //     throw Exception("list not found");
  //   }
  // }

  // // Read Item Stream
  // Stream<List<Item>> getItemStream(Board list) {
  //   var ref = db
  //       .collection('users')
  //       .doc(list.uid)
  //       .collection('lists')
  //       .doc(list.id)
  //       .collection('items');
  //   return ref.snapshots().map((snapshot) =>
  //       snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList());
  // }

  // // Read Item:
  // Future<Item> getItem(String itemID, String listID) async {
  //   // grab current user
  //   var user = auth.user!;

  //   var ref = db
  //       .collection('users')
  //       .doc(user.uid)
  //       .collection('lists')
  //       .doc(listID)
  //       .collection('items')
  //       .doc(itemID);
  //   var snapshot = await ref.get();
  //   // return json map
  //   return Item.fromJson(snapshot.data() ?? {});
  // }

  // // // Update Item:
  // // Future<void> updateItem(
  // //     String title, String description, String itemID, String listID) async {
  // //   // grab current user
  // //   Item updatedItem = Item(
  // //     id: itemID,
  // //     title: title,
  // //     description: description,
  // //   );
  // //   await FirestoreService().updateItemInList(listID, updatedItem);
  // // }

  // Future<void> updateItemInList(String listID, Item updatedItem) async {
  //   // grab current user
  //   var user = auth.user!;

  //   var listRef =
  //       db.collection('users').doc(user.uid).collection('lists').doc(listID);
  //   var itemRef = listRef.collection('items').doc(updatedItem.id);
  //   var data = {
  //     'title': updatedItem.title,
  //     'description': updatedItem.description,
  //   };
  //   DocumentSnapshot listDoc = await listRef.get();
  //   if (listDoc.exists) {
  //     Board itemList = Board.fromFirestore(listDoc);
  //     List<Item> updatedItems = itemList.items.map((item) {
  //       return item.id == updatedItem.id ? updatedItem : item;
  //     }).toList();

  //     await listRef.update({
  //       'items': updatedItems.map((item) => item.toJson()).toList(),
  //     });
  //     await itemRef.set(data, SetOptions(merge: true));
  //   } else {
  //     throw Exception("list not found");
  //   }
  // }

  // // // Delete Item:
  // // Future<void> deleteItem(Board list, String itemID) async {
  // //   try {
  // //     // reference to the list
  // //     var ref = db
  // //         .collection('users')
  // //         .doc(list.uid)
  // //         .collection('lists')
  // //         .doc(list.id)
  // //         .collection('items')
  // //         .doc(itemID);
  // //     return ref.delete();
  // //   } catch (e) {
  // //     print("error deleting item: $e");
  // //     rethrow;
  // //   }
  // // }
}
