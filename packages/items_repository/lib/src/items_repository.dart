import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:boards_repository/boards_repository.dart';
import 'package:items_repository/src/failures.dart';
import 'package:items_repository/src/models/models.dart';
import 'package:user_repository/user_repository.dart';

class ItemsRepository {
  ItemsRepository({
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
          await _storage.uploadFile('items/$doc/cover_image.jpeg', file);
      // save photoURL to document
      await _firestore.updateItemDoc(doc, {'photoURL': url});
      return url;
    } catch (e) {
      return null;
    }
  }
}

extension Create on ItemsRepository {
  // create an item
  Future<String> createItem(Item item, String userID) async {
    try {
      return await _firestore.runTransaction((transaction) async {
        // get references
        final userRef = _firestore.userDoc(userID);
        final itemRef = _firestore.collection('items').doc();

        // get user doc
        final userSnapshot = await transaction.get(userRef);
        if (!userSnapshot.exists) throw Exception('User does not exist');

        // update user doc
        transaction.update(userRef, {
          'items': FieldValue.arrayUnion([itemRef.id]),
        });

        // prepare data for the new item
        final newItem = item.toJson();
        newItem['id'] = itemRef.id;
        newItem['uid'] = userID;
        newItem['createdAt'] = Timestamp.now();

        // preform writes
        transaction.set(itemRef, newItem);

        // return id
        return itemRef.id;
      });
    } on FirebaseException {
      throw ItemFailure.fromCreateItem();
    }
  }
}

extension Read on ItemsRepository {
  // get item document
  Future<Item> readItem(String itemID) async {
    try {
      // get document from database
      final doc = await _firestore.getItemDoc(itemID);
      if (doc.exists) {
        final data = doc.data();
        // return board
        return Item.fromJson(data!);
      } else {
        // return empty board if document DNE
        return Item.empty;
      }
    } on FirebaseException {
      // return failure
      throw ItemFailure.fromGetItem();
    }
  }

  // stream item data
  Stream<Item> readItemStream(String itemID) {
    return _firestore.itemDoc(itemID).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return Item.fromJson(snapshot.data()!);
      } else {
        throw Exception('Item not found');
      }
    });
  }

  // stream items
  Stream<List<Item>> streamItems() {
    try {
      return _firestore
          .itemsCollection()
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        try {
          return snapshot.docs
              .map((doc) {
                return Item.fromJson(doc.data());
              })
              .whereType<Item>()
              .toList();
        } catch (error) {
          return [];
        }
      });
    } on FirebaseException {
      // return failure
      throw ItemFailure.fromGetItem();
    }
  }

  // get item likes
  Future<int> readLikes(String itemID) async {
    try {
      // get document from database
      final doc = await _firestore.getItemDoc(itemID);
      if (doc.exists) {
        // return board
        final data = Item.fromJson(doc.data()!);
        return data.likes;
      } else {
        // return empty board if document DNE
        return 0;
      }
    } on FirebaseException {
      // return failure
      throw ItemFailure.fromGetItem();
    }
  }
}

extension Update on ItemsRepository {
  // update specific user field
  Future<void> updateField(String itemID, String field, String data) async {
    try {
      await _firestore.updateItemDoc(itemID, {field: data});
    } on FirebaseException {
      throw ItemFailure.fromUpdateItem();
    }
  }

  // update liked items
  // using batch to handle updating user, item, and board docs at the same time
  Future<int> updateItemLikes({
    required String userID,
    required String itemID,
    required bool isLiked,
  }) async {
    try {
      // get document references
      final userRef = _firestore.userDoc(userID);
      final itemRef = _firestore.itemDoc(itemID);

      // user batch to perform atomic operation
      final batch = _firestore.batch();

      // get document data
      final userSnapshot = await userRef.get();
      final itemSnapshot = await itemRef.get();

      // make sure user exists
      if (!userSnapshot.exists || !itemSnapshot.exists) {
        throw Exception('Data does not exist!');
      }

      // get user
      final user = await UserRepository().getUserById(userID);
      final boardID = user.likedItemsBoardID;
      final boardRef = _firestore.boardDoc(boardID);

      // get liked board's items or init if does not exist
      final boardItems = await BoardsRepository().readItems(boardID);

      // update item documents based on isLiked value
      if (!isLiked) {
        // update item doc
        batch.update(itemRef, {
          'likedBy': FieldValue.arrayUnion([userID]),
          'likes': FieldValue.increment(1),
        });
        // update user doc
        if (!user.likedItems.contains(itemID)) user.likedItems.add(itemID);
        // update board doc
        if (!boardItems.contains(itemID)) boardItems.add(itemID);
      } else {
        // update item doc
        batch.update(itemRef, {
          'likedBy': FieldValue.arrayRemove([userID]),
          'likes': FieldValue.increment(-1),
        });
        // update user doc
        user.likedItems.remove(itemID);
        // update board doc
        boardItems.remove(itemID);
      }
      // batch update
      batch
        ..update(userRef, {'likedItems': user.likedItems})
        ..update(boardRef, {'items': boardItems});

      // commit changes
      await batch.commit();

      return readLikes(itemID);
    } on FirebaseException {
      throw ItemFailure.fromUpdateItem();
    }
  }
}

extension Delete on ItemsRepository {
  // delete item:
  // we need to delete the item at all reference points
  Future<void> deleteItem(String userID, String itemID, String photoURL) async {
    try {
      // start batch
      final batch = _firestore.batch();

      // get references
      final userRef = _firestore.userDoc(userID);
      final itemRef = _firestore.itemDoc(itemID);

      // ensure existing docs
      final userSnapshot = await userRef.get();
      final itemSnapshot = await itemRef.get();

      // throw errors
      if (!userSnapshot.exists || !itemSnapshot.exists) {
        throw Exception('Data does not exists!');
      }

      print('item exists');
      // delete image
      if (photoURL.isNotEmpty) {
        await _storage.deleteFile('items/$itemID/cover_image.jpeg');
      }
      print('deleted image');
      // delete item ref
      batch.delete(itemRef);
      print('deleted item');
      // find all boards that contain the item
      final boardsSnapshot = await _firestore
          .boardsCollection()
          .where('items', arrayContains: itemID)
          .get();

      // remove item reference from each board
      for (final boardDoc in boardsSnapshot.docs) {
        // get liked board's items or init if does not exist
        final boardItems = await BoardsRepository().readItems(boardDoc.id);
        boardItems.remove(itemID);
        batch.update(boardDoc.reference, {'items': boardItems});
      }

      print('removed item from boards');

      final user = await UserRepository().getUserById(userID);
      user.likedItems.remove(itemID);
      user.items.remove(itemID);

      batch.update(userRef, {
        'items': user.items,
        'likedItems': user.likedItems,
      });
      print('removed item from user doc');

      // commit changes
      await batch.commit();
    } on FirebaseException {
      throw ItemFailure.fromDeleteItem();
    }
  }
}
