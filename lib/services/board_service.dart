// // dart packages
// import 'dart:async';

// // utils
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:logger/logger.dart';
// import 'package:rando/services/storage.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:rando/services/auth.dart';
// import 'package:rando/services/models.dart';

class BoardService {
  // firestore database
  // final FirebaseFirestore db = FirebaseFirestore.instance;
  // final StorageService storage = StorageService();
  // final AuthService auth = AuthService();
  // final Logger logger = Logger();

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
  // Future<void> addItemToList(ItemData item, String listID) async {
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
  //     BoardData itemList = BoardData.fromFirestore(listDoc);
  //     // add the new item to the list of items
  //     List<ItemData> updatedItems = [...itemList.items, item];
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
