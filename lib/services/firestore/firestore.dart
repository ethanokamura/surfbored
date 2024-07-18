// dart packages
import 'dart:async';

// utils
import 'package:logger/logger.dart';
import 'package:rando/services/storage.dart';
import 'package:rando/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // firestore database reference
  final FirebaseFirestore db = FirebaseFirestore.instance;
  // firebase storage reference
  final StorageService storage = StorageService();
  // firestore functions for user auth
  final AuthService auth = AuthService();
  // handles pretty printing
  final Logger logger = Logger();

  FirestoreService();

  Future<void> setPhotoURL(
    String collection,
    String docID,
    String imgURL,
  ) async {
    var ref = db.collection(collection).doc(docID);
    // save photoURL in user doc
    await ref.set({'imgURL': imgURL}, SetOptions(merge: true));
  }

  Stream<int> getLikesStream(String collection, String docID) {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(docID)
        .snapshots()
        .map((snapshot) => snapshot.data()?['likes'] ?? 0);
  }
}
