import 'package:api_client/api_client.dart';
import 'package:post_repository/src/failures.dart';
import 'package:post_repository/src/models/models.dart';

class PostRepository {
  PostRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
}

extension Create on PostRepository {
  // create an post
  Future<String> createPost(Post post, String userID) async {
    try {
      final postRef = _firestore.postsCollection().doc();

      // set data
      final newPost = post.toJson();
      newPost['id'] = postRef.id;
      newPost['uid'] = userID;
      newPost['createdAt'] = Timestamp.now();

      // post data
      await postRef.set(newPost);
      await _firestore.setLikeDoc(postRef.id, {'users': <String>[]});
      await _firestore.updateUserDoc(userID, {
        'posts': FieldValue.arrayUnion([postRef.id]),
      });

      // return doc ID
      return postRef.id;
    } on FirebaseException {
      throw PostFailure.fromCreatePost();
    }
  }
}

extension Fetch on PostRepository {
  // get post document
  Future<Post> fetchPost(String postID) async {
    try {
      // get document from database
      final doc = await _firestore.getPostDoc(postID);
      if (doc.exists) {
        final data = doc.data();
        // return board
        return Post.fromJson(data!);
      } else {
        // return empty board if document DNE
        return Post.empty;
      }
    } on FirebaseException {
      // return failure
      throw PostFailure.fromGetPost();
    }
  }

  // get post likes
  Future<int> fetchLikes(String postID) async {
    try {
      // get document from database
      final doc = await _firestore.getPostDoc(postID);
      if (doc.exists) {
        // return board
        final data = Post.fromJson(doc.data()!);
        return data.likes;
      } else {
        // return empty board if document DNE
        return 0;
      }
    } on FirebaseException {
      // return failure
      throw PostFailure.fromGetPost();
    }
  }
}

extension StreamData on PostRepository {
  // stream post data
  Stream<Post> streamPost(String postID) {
    try {
      return _firestore.postDoc(postID).snapshots().map((snapshot) {
        if (snapshot.exists) {
          return Post.fromJson(snapshot.data()!);
        } else {
          throw PostFailure.fromGetPost();
        }
      });
    } on FirebaseException {
      throw PostFailure.fromGetPost();
    }
  }

  // stream posts
  Stream<List<Post>> streamPosts() {
    try {
      return _firestore
          .postsCollection()
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
        try {
          return snapshot.docs
              .map((doc) => Post.fromJson(doc.data()))
              .whereType<Post>()
              .toList();
        } catch (error) {
          return [];
        }
      });
    } on FirebaseException {
      // return failure
      throw PostFailure.fromGetPost();
    }
  }
}

extension Update on PostRepository {
  // update specific user field
  Future<void> updateField(String postID, String field, String data) async {
    try {
      await _firestore.updatePostDoc(postID, {field: data});
    } on FirebaseException {
      throw PostFailure.fromUpdatePost();
    }
  }

  // update liked posts
  Future<int> updateLikes({
    required String userID,
    required String postID,
    required bool isLiked,
  }) async {
    try {
      // get document references
      final userRef = _firestore.userDoc(userID);
      final postRef = _firestore.postDoc(postID);
      final likesRef = _firestore.likeDoc(postID);

      // user batch to perform atomic operation
      final batch = _firestore.batch();

      // get document data
      final userSnapshot = await userRef.get();
      final postSnapshot = await postRef.get();
      final likeSnapshot = await likesRef.get();

      // make sure user exists
      if (!userSnapshot.exists ||
          !postSnapshot.exists ||
          !likeSnapshot.exists) {
        throw PostFailure.fromUpdatePost();
      }

      if (!isLiked) {
        batch
          ..update(userRef, {
            'likedPosts': FieldValue.arrayUnion([postID]),
          })
          ..update(likesRef, {
            'users': FieldValue.arrayUnion([userID]),
          })
          ..update(postRef, {
            'likes': FieldValue.increment(1),
          });
      } else {
        batch
          ..update(userRef, {
            'likedPosts': FieldValue.arrayRemove([postID]),
          })
          ..update(likesRef, {
            'users': FieldValue.arrayRemove([userID]),
          })
          ..update(postRef, {
            'likes': FieldValue.increment(-1),
          });
      }
      // commit changes
      await batch.commit();

      return fetchLikes(postID);
    } on FirebaseException {
      throw PostFailure.fromUpdatePost();
    }
  }
}

extension Delete on PostRepository {
  // delete post:
  Future<void> deletePost(String userID, String postID, String photoURL) async {
    final batch = _firestore.batch();
    final postRef = _firestore.postDoc(postID);
    final likeRef = _firestore.likeDoc(postID);
    const batchSize = 500; // Firestore batch limit

    try {
      final postDoc = await postRef.get();
      if (!postDoc.exists) {
        throw PostFailure.fromGetPost();
      }

      batch
        ..delete(postRef)
        ..delete(likeRef);

      // find all boards containing this post
      final boardsQuery = _firestore
          .boardsCollection()
          .where('posts', arrayContains: postID)
          .limit(batchSize);

      await _firestore.processQueryInBatches(boardsQuery, batch, (boardDoc) {
        batch.update(boardDoc.reference, {
          'posts': FieldValue.arrayRemove([postID]),
        });
      });

      // find all users who liked this post
      final usersQuery = _firestore
          .collection('users')
          .where('likedPosts', arrayContains: postID)
          .limit(batchSize);

      await _firestore.processQueryInBatches(usersQuery, batch, (userDoc) {
        batch.update(userDoc.reference, {
          'likedPosts': FieldValue.arrayRemove([postID]),
        });
      });

      await _firestore.updateUserDoc(userID, {
        'posts': FieldValue.arrayRemove([postID]),
      });

      // Optionally delete the associated image file
      if (photoURL.isNotEmpty) {
        await _storage.refFromURL(photoURL).delete();
      }

      await batch.commit();
    } on FirebaseException {
      throw PostFailure.fromDeletePost();
    }
  }
}
