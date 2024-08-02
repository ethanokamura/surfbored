import 'package:api_client/api_client.dart';
import 'package:tag_repository/src/failures.dart';
import 'package:tag_repository/src/models/models.dart';

class TagRepository {
  TagRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
}

extension Create on TagRepository {
  Future<void> createTag(Tag tag) async {
    try {
      final tagRef = _firestore.tagsCollection().doc();
      final newTag = tag.toJson();
      newTag['id'] = tagRef.id;
      await _firestore.setTagDoc(tag.id, newTag);
    } on FirebaseException {
      throw TagFailure.fromCreateTag();
    }
  }
}

extension Fetch on TagRepository {
  // query database to see if the tag already exists
  Future<bool> isTagUnique(String name) async {
    try {
      final querySnapshot = await _firestore
          .tagsCollection()
          .where('name', isEqualTo: name)
          .limit(1)
          .get();
      return querySnapshot.docs.isEmpty;
    } on FirebaseException {
      // return failure
      throw TagFailure.fromGetTag();
    }
  }

  // fetch tag ID by name
  Future<String?> fetchTagByName(String name) async {
    try {
      final querySnapshot = await _firestore
          .tagsCollection()
          .where('name', isEqualTo: name)
          .limit(1)
          .get();
      if (querySnapshot.docs.isEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        return null;
      }
    } on FirebaseException {
      // return failure
      throw TagFailure.fromGetTag();
    }
  }

  // fetch tag by ID
  Future<Tag> fetchTag(String tagID) async {
    try {
      // get document from database
      final doc = await _firestore.getTagDoc(tagID);
      if (doc.exists) {
        // return tag
        final data = Tag.fromJson(doc.data()!);
        return data;
      } else {
        return Tag.empty;
      }
    } on FirebaseException {
      // return failure
      throw TagFailure.fromGetTag();
    }
  }

  // fetch the amount of time the tag was used
  Future<int> fetchTagUsage(String tagID) async {
    try {
      // get document from database
      final doc = await _firestore.getTagDoc(tagID);
      if (doc.exists) {
        // return tag usage
        final data = Tag.fromJson(doc.data()!);
        return data.usageCount;
      } else {
        return 0;
      }
    } on FirebaseException {
      // return failure
      throw TagFailure.fromGetTag();
    }
  }
}

extension Streams on TagRepository {
  Stream<List<Tag>> streamTags() {
    try {
      return _firestore
          .collection('tags')
          .snapshots()
          .map((snapshot) => snapshot.docs.map(Tag.fromFirestore).toList());
    } on FirebaseException {
      // return failure
      throw TagFailure.fromGetTag();
    }
  }

  Stream<List<Tag>> streamTagsByUsage() {
    try {
      return _firestore
          .collection('tags')
          .orderBy('usageCount', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map(Tag.fromFirestore).toList());
    } on FirebaseException {
      // return failure
      throw TagFailure.fromGetTag();
    }
  }

  Stream<List<Tag>> streamTagsByCategory(String category) {
    return _firestore
        .collection('tags')
        .orderBy('usageCount', descending: true)
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Tag.fromFirestore).toList());
  }
}

extension Update on TagRepository {
  Future<void> updateTagUsage(String tagID, int increment) async {
    await _firestore.tagDoc(tagID).update({
      'usageCount': FieldValue.increment(increment),
    });
  }
}

extension Delete on TagRepository {}
