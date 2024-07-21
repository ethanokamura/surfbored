// dart packages
import 'dart:async';
import 'dart:io';

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

  Future<String?> uploadImage(
    File file,
    String path,
    String collection,
    String docID,
  ) async {
    try {
      // get firestore ref
      var ref = db.collection(collection).doc(docID);
      // get photoURL
      String url = await storage.uploadFile(path, file);
      // save photoURL in user doc
      await ref.update({'imgURL': url});
      return url;
    } catch (e) {
      return null;
    }
  }

  Stream<int> getLikesStream(String collection, String docID) {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(docID)
        .snapshots()
        .map((snapshot) => snapshot.data()?['likes'] ?? 0);
  }
}
