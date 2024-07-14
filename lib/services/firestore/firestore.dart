import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> setPhotoURL(
    String collectionName,
    String docID,
    String filepath,
  ) async {
    var ref = db.collection(collectionName).doc(docID);
    // save photoURL in user doc
    await ref.set({'imgURL': '$collectionName/$docID/$filepath'},
        SetOptions(merge: true));
  }
}
