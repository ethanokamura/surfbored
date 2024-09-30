import 'package:api_client/api_client.dart';
import 'package:post_repository/src/failures.dart';
import 'package:post_repository/src/models/post.dart';

class PostRepository {
  PostRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
}

extension Create on PostRepository {
  // create an post
  Future<String> createPost(Post post, String userID) async {
    final batch = _firestore.batch();
    final postRef = _firestore.postsCollection().doc();
    final userRef = _firestore.userDoc(userID);
    try {
      final newPost = post.toJson()
        ..addAll({
          'id': postRef.id,
          'uid': userID,
          'createdAt': Timestamp.now(),
        });
      batch
        ..set(postRef, newPost)
        ..update(userRef, {
          'posts': FieldValue.arrayUnion([postRef.id]),
        });
      await batch.commit();
      return postRef.id;
    } on FirebaseException {
      throw PostFailure.fromCreatePost();
    }
  }
}

extension Fetch on PostRepository {
  // fetch post
  Future<Post> fetchPost(String postID) async {
    try {
      final doc = await _firestore.getPostDoc(postID);
      if (!doc.exists) return Post.empty;
      final data = doc.data();
      return Post.fromJson(data!);
    } on FirebaseException {
      // return failure
      throw PostFailure.fromGetPost();
    }
  }

  // fetch all the post from a board
  Future<List<Post>> fetchBoardPosts(String boardID) async {
    try {
      final boardDoc = await _firestore.getBoardDoc(boardID);
      if (!boardDoc.exists) return [];
      final boardData = boardDoc.data()!;

      final postIDs = List<String>.from(
        (boardData['posts'] as List).map((post) => post as String),
      );
      final postDocs = await Future.wait(postIDs.map(_firestore.getPostDoc));

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

      return posts;
    } on FirebaseException {
      // return failure
      throw PostFailure.fromGetPost();
    }
  }

  // fetch post's likes
  Future<int> fetchLikes(String postID) async {
    try {
      final doc = await _firestore.getPostDoc(postID);
      if (!doc.exists) return 0;
      final data = Post.fromJson(doc.data()!);
      return data.likes;
    } on FirebaseException {
      throw PostFailure.fromGetPost();
    }
  }

  // fetch post's likes
  Future<int> fetchComments(String postID) async {
    try {
      final doc = await _firestore.getPostDoc(postID);
      if (!doc.exists) return 0;
      final data = Post.fromJson(doc.data()!);
      return data.comments;
    } on FirebaseException {
      throw PostFailure.fromGetPost();
    }
  }

  Future<bool> hasUserLikedPost(String postID, String userID) async {
    try {
      final likeDoc = await _firestore.getLikeDoc('${postID}_$userID');
      return likeDoc.exists;
    } on FirebaseException {
      throw PostFailure.fromGetPost();
    }
  }
}

extension StreamData on PostRepository {
  // stream post data
  Stream<Post> streamPost(String postID) {
    try {
      return _firestore.postDoc(postID).snapshots().map((snapshot) {
        if (snapshot.exists) return Post.fromJson(snapshot.data()!);
        throw PostFailure.fromGetPost();
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

  // stream all the user's posts using pagination
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

    final postIDs = List<String>.from(
      (userDoc.data()!['posts'] as List).map((post) => post as String),
    );

    final reversedPostIDs = postIDs.reversed.toList();

    yield* streamPostsByIDs(pageSize, page, reversedPostIDs);
  }

  // stream all the board's posts using pagination
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

    final postIDs = List<String>.from(
      (boardDoc.data()!['posts'] as List).map((post) => post as String),
    );

    final reversedPostIDs = postIDs.reversed.toList();

    yield* streamPostsByIDs(pageSize, page, reversedPostIDs);
  }

  // stream all the user's liked posts using pagination
  Stream<List<Post>> streamUserLikedPosts(
    String userID, {
    int pageSize = 10,
    int page = 0,
  }) async* {
    // get post ID
    final likedPostsSnapshot = await _firestore
        .collection('likes')
        .where('userID', isEqualTo: userID)
        .orderBy('timestamp', descending: true)
        .limit(pageSize * (page + 1)) // Fetch only necessary pages
        .get();

    final postIDs = likedPostsSnapshot.docs
        .map((doc) => doc.data()['postID'] as String)
        .toList();

    yield* streamPostsByIDs(pageSize, page, postIDs);
  }

  // generic post stream
  Stream<List<Post>> streamPostsByIDs(
    int pageSize,
    int page,
    List<String> postIDs,
  ) async* {
    final buffer = <Post>[];
    final startIndex = page * pageSize;

    if (startIndex >= postIDs.length) {
      yield buffer;
      return;
    }

    final postIDsPage = postIDs.skip(startIndex).take(pageSize).toList();
    final postDocs = await _firestore
        .postsCollection()
        .where(FieldPath.documentId, whereIn: postIDsPage)
        .get();

    // Process documents and add to buffer
    for (final doc in postDocs.docs) {
      buffer.add(Post.fromFirestore(doc));
    }

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
  Future<void> updateLikes({
    required String postID,
    required String userID,
    required String ownerID,
    required bool isLiked,
  }) async {
    final postRef = _firestore.postDoc(postID);
    final likeRef = _firestore.likeDoc('${postID}_$userID');
    final batch = _firestore.batch();

    try {
      if (!isLiked) {
        batch
          ..update(postRef, {'likes': FieldValue.increment(1)})
          ..set(likeRef, {
            'postID': postID,
            'userID': userID,
            'ownerID': ownerID,
            'timestamp': FieldValue.serverTimestamp(),
          });
      } else {
        batch
          ..update(postRef, {'likes': FieldValue.increment(-1)})
          ..delete(likeRef);
      }
      // commit changes
      await batch.commit();
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
    const batchSize = 500;
    try {
      final postDoc = await postRef.get();
      if (!postDoc.exists) {
        throw PostFailure.fromGetPost();
      }

      batch
        ..delete(postRef)
        ..update(_firestore.userDoc(userID), {
          'posts': FieldValue.arrayRemove([postID]),
        });

      // find all boards containing this post
      final likesQuery = _firestore
          .likesCollection()
          .where('postID', arrayContains: postID)
          .limit(batchSize);

      // delete all docs
      await _firestore.deleteDocumentsByQuery(likesQuery, batch);

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

      // // Optionally delete the associated image file
      // if (photoURL.isNotEmpty) {
      //   await _storage.refFromURL(photoURL).delete();
      // }

      await batch.commit();
    } on FirebaseException {
      throw PostFailure.fromDeletePost();
    }
  }
}
