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
        // return likes
        final data = Post.fromJson(doc.data()!);
        return data.likes;
      } else {
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
  Stream<List<Post>> streamPosts({
    DocumentSnapshot? startAfter,
    int limit = 10,
  }) {
    try {
      var query = _firestore
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      return query.snapshots().map((snapshot) {
        try {
          return snapshot.docs
              .map(Post.fromFirestore)
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

  Stream<List<Post>> streamUserPosts(
    String userID, {
    int pageSize = 10,
    int page = 0,
  }) async* {
    final userDoc = await _firestore.getUserDoc(userID);

    if (!userDoc.exists) {
      yield [];
      return;
    }

    final userData = userDoc.data()!;
    final postIDs = List<String>.from(
      (userData['posts'] as List).map((post) => post as String),
    );

    final reversedPostIDs = postIDs.reversed.toList();

    final buffer = <Post>[];
    final startIndex = page * pageSize;

    if (startIndex >= reversedPostIDs.length) {
      yield buffer;
      return;
    }

    final postIDsPage =
        reversedPostIDs.skip(startIndex).take(pageSize).toList();
    final postDocs = await Future.wait(postIDsPage.map(_firestore.getPostDoc));
    final posts = postDocs
        .map((doc) {
          if (doc.exists) {
            return Post.fromFirestore(doc);
          } else {
            return null;
          }
        })
        .whereType<Post>()
        .toList();

    buffer.addAll(posts);

    yield buffer;
  }

  Stream<List<Post>> streamUserLikedPosts(
    String userID, {
    int pageSize = 10,
    int page = 0,
  }) async* {
    final userDoc = await _firestore.getUserDoc(userID);

    if (!userDoc.exists) {
      yield [];
      return;
    }

    final userData = userDoc.data()!;
    final postIDs = List<String>.from(
      (userData['likedPosts'] as List).map((post) => post as String),
    );

    final reversedPostIDs = postIDs.reversed.toList();

    final buffer = <Post>[];
    final startIndex = page * pageSize;

    if (startIndex >= reversedPostIDs.length) {
      yield buffer;
      return;
    }

    final postIDsPage =
        reversedPostIDs.skip(startIndex).take(pageSize).toList();
    final postDocs = await Future.wait(postIDsPage.map(_firestore.getPostDoc));
    final posts = postDocs
        .map((doc) {
          if (doc.exists) {
            return Post.fromFirestore(doc);
          } else {
            return null;
          }
        })
        .whereType<Post>()
        .toList();

    buffer.addAll(posts);

    yield buffer;
  }

  Stream<List<Post>> streamBoardPosts(
    String boardID, {
    int pageSize = 10,
    int page = 0,
  }) async* {
    final boardDoc = await _firestore.getBoardDoc(boardID);

    if (!boardDoc.exists) {
      yield [];
      return;
    }

    final boardData = boardDoc.data()!;
    final postIDs = List<String>.from(
      (boardData['posts'] as List).map((post) => post as String),
    );

    final reversedPostIDs = postIDs.reversed.toList();

    final buffer = <Post>[];
    final startIndex = page * pageSize;

    if (startIndex >= reversedPostIDs.length) {
      yield buffer;
      return;
    }

    // Fetch the next page of post IDs
    final postIDsPage =
        reversedPostIDs.skip(startIndex).take(pageSize).toList();
    final postDocs = await Future.wait(
      postIDsPage.map(_firestore.getPostDoc),
    );
    // Add the fetched board IDs to the buffer
    final posts = postDocs
        .map((doc) {
          if (doc.exists) {
            return Post.fromFirestore(doc);
          } else {
            return null;
          }
        })
        .whereType<Post>()
        .toList();
    buffer.addAll(posts);

    // Emit the current buffer as a stream event
    yield buffer;
  }
}

extension Update on PostRepository {
  // update specific user field
  Future<void> updateField(String postID, Map<String, dynamic> data) async {
    try {
      await _firestore.updatePostDoc(postID, data);
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
          ..update(postRef, {
            'likes': FieldValue.increment(1),
          })
          ..update(likesRef, {
            'users': FieldValue.arrayUnion([userID]),
          });
      } else {
        batch
          ..update(userRef, {
            'likedPosts': FieldValue.arrayRemove([postID]),
          })
          ..update(postRef, {
            'likes': FieldValue.increment(-1),
          })
          ..update(likesRef, {
            'users': FieldValue.arrayRemove([userID]),
          });
      }
      // commit changes
      try {
        await batch.commit();
      } catch (e) {
        // something failed with batch.commit().
        // the batch was rolled back.
        print('could not commit changes $e');
      }
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
