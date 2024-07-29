import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:board_repository/board_repository.dart';
import 'package:post_repository/src/failures.dart';
import 'package:post_repository/src/models/models.dart';
import 'package:user_repository/user_repository.dart';

class PostRepository {
  PostRepository({
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
          await _storage.uploadFile('posts/$doc/cover_image.jpeg', file);
      // save photoURL to document
      await _firestore.updatePostDoc(doc, {'photoURL': url});
      return url;
    } catch (e) {
      return null;
    }
  }
}

extension Create on PostRepository {
  // create an post
  Future<String> createPost(Post post, String userID) async {
    try {
      return await _firestore.runTransaction((transaction) async {
        // get references
        final userRef = _firestore.userDoc(userID);
        final postRef = _firestore.collection('posts').doc();

        // get user doc
        final userSnapshot = await transaction.get(userRef);
        if (!userSnapshot.exists) throw Exception('User does not exist');

        // update user doc
        transaction.update(userRef, {
          'posts': FieldValue.arrayUnion([postRef.id]),
        });

        // prepare data for the new post
        final newPost = post.toJson();
        newPost['id'] = postRef.id;
        newPost['uid'] = userID;
        newPost['createdAt'] = Timestamp.now();

        // preform writes
        transaction.set(postRef, newPost);

        // return id
        return postRef.id;
      });
    } on FirebaseException {
      throw PostFailure.fromCreatePost();
    }
  }
}

extension Read on PostRepository {
  // get post document
  Future<Post> readPost(String postID) async {
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

  // stream post data
  Stream<Post> readPostStream(String postID) {
    return _firestore.postDoc(postID).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return Post.fromJson(snapshot.data()!);
      } else {
        throw Exception('Post not found');
      }
    });
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
              .map((doc) {
                return Post.fromJson(doc.data());
              })
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

  // get post likes
  Future<int> readLikes(String postID) async {
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
  // using batch to handle updating user, post, and board docs at the same time
  Future<int> updatePostLikes({
    required String userID,
    required String postID,
    required bool isLiked,
  }) async {
    try {
      // get document references
      final userRef = _firestore.userDoc(userID);
      final postRef = _firestore.postDoc(postID);

      // user batch to perform atomic operation
      final batch = _firestore.batch();

      // get document data
      final userSnapshot = await userRef.get();
      final postSnapshot = await postRef.get();

      // make sure user exists
      if (!userSnapshot.exists || !postSnapshot.exists) {
        throw Exception('Data does not exist!');
      }

      // get user
      final user = await UserRepository().getUserById(userID);
      final boardID = user.likedPostsBoardID;
      final boardRef = _firestore.boardDoc(boardID);

      // get liked board's posts or init if does not exist
      final boardPosts = await BoardRepository().readPosts(boardID);

      // update post documents based on isLiked value
      if (!isLiked) {
        // update post doc
        batch.update(postRef, {
          'likedBy': FieldValue.arrayUnion([userID]),
          'likes': FieldValue.increment(1),
        });
        // update user doc
        if (!user.likedPosts.contains(postID)) user.likedPosts.add(postID);
        // update board doc
        if (!boardPosts.contains(postID)) boardPosts.add(postID);
      } else {
        // update post doc
        batch.update(postRef, {
          'likedBy': FieldValue.arrayRemove([userID]),
          'likes': FieldValue.increment(-1),
        });
        // update user doc
        user.likedPosts.remove(postID);
        // update board doc
        boardPosts.remove(postID);
      }
      // batch update
      batch
        ..update(userRef, {'likedPosts': user.likedPosts})
        ..update(boardRef, {'posts': boardPosts});

      // commit changes
      await batch.commit();

      return readLikes(postID);
    } on FirebaseException {
      throw PostFailure.fromUpdatePost();
    }
  }
}

extension Delete on PostRepository {
  // delete post:
  // we need to delete the post at all reference points
  Future<void> deletePost(String userID, String postID, String photoURL) async {
    try {
      // start batch
      final batch = _firestore.batch();

      // get references
      final userRef = _firestore.userDoc(userID);
      final postRef = _firestore.postDoc(postID);

      // ensure existing docs
      final userSnapshot = await userRef.get();
      final postSnapshot = await postRef.get();

      // throw errors
      if (!userSnapshot.exists || !postSnapshot.exists) {
        throw Exception('Data does not exists!');
      }

      // delete image
      if (photoURL.isNotEmpty) {
        await _storage.deleteFile('posts/$postID/cover_image.jpeg');
      }

      // delete post ref
      batch.delete(postRef);

      // find all boards that contain the post
      final boardsSnapshot = await _firestore
          .boardsCollection()
          .where('posts', arrayContains: postID)
          .get();

      // remove post reference from each board
      for (final boardDoc in boardsSnapshot.docs) {
        // get liked board's posts or init if does not exist
        final boardPosts = await BoardRepository().readPosts(boardDoc.id);
        boardPosts.remove(postID);
        batch.update(boardDoc.reference, {'posts': boardPosts});
      }

      final user = await UserRepository().getUserById(userID);
      user.likedPosts.remove(postID);
      user.posts.remove(postID);

      batch.update(userRef, {
        'posts': user.posts,
        'likedPosts': user.likedPosts,
      });

      // commit changes
      await batch.commit();
    } on FirebaseException {
      throw PostFailure.fromDeletePost();
    }
  }
}
