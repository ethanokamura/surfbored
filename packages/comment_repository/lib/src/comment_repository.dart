import 'package:api_client/api_client.dart';
import 'package:comment_repository/src/failures.dart';
import 'package:comment_repository/src/models/models.dart';

class CommentPage {
  CommentPage({
    required this.comments,
    required this.lastDocument,
  });
  final List<Comment> comments;
  final DocumentSnapshot? lastDocument;
}

class CommentRepository {
  CommentRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  // create comment
  Future<String> createComment(
    Comment comment,
    String postID,
  ) async {
    final batch = _firestore.batch();
    final postRef = _firestore.postDoc(postID);
    final commentRef = postRef.collection('comments').doc();
    try {
      final newComment = comment.toJson()
        ..addAll({
          'id': commentRef.id,
          'createdAt': Timestamp.now(),
        });
      batch
        ..set(commentRef, newComment)
        ..update(postRef, {'comments': FieldValue.increment(1)});
      await batch.commit();
      return commentRef.id;
    } on FirebaseException {
      throw CommentFailure.fromCreateComment();
    }
  }

  // read comment
  Future<Comment> fetchComment(String postID, String commentID) async {
    try {
      final doc = await _firestore.getCommentDoc(postID, commentID);
      if (!doc.exists) return Comment.empty;
      final data = doc.data();
      return Comment.fromJson(data!);
    } on FirebaseException {
      // return failure
      throw CommentFailure.fromGetComment();
    }
  }

  // fetch post's likes
  Future<int> fetchLikes(String postID, String commentID) async {
    try {
      final doc = await _firestore.getCommentDoc(postID, commentID);
      if (!doc.exists) return 0;
      final data = Comment.fromJson(doc.data()!);
      return data.likes;
    } on FirebaseException {
      throw CommentFailure.fromGetComment();
    }
  }

  Stream<List<Comment>> streamComments({
    required String postID,
    int limit = 50,
  }) {
    try {
      final query = _firestore
          .commentsCollection(postID)
          .orderBy('createdAt', descending: true)
          .limit(limit);
      return query.snapshots().map((snapshot) {
        if (snapshot.docs.isEmpty) {
          return [];
        }
        final comments = snapshot.docs
            .map(Comment.fromFirestore)
            .whereType<Comment>()
            .toList();
        return comments;
      });
    } on FirebaseException {
      throw CommentFailure.fromGetComment();
    }
  }

  // update comment
  Future<void> updateComment(
    String postID,
    String commentID,
    String comment,
  ) async {
    try {
      await _firestore.updateCommentDoc(postID, commentID, {
        'message': comment,
        'edited': true,
      });
    } on FirebaseException {
      throw CommentFailure.fromUpdateComment();
    }
  }

  // update liked posts
  Future<void> updateLikes({
    required String postID,
    required String commentID,
    required String userID,
    required bool liked,
  }) async {
    try {
      if (liked) {
        await _firestore.updateCommentDoc(
          postID,
          commentID,
          {
            'likes': FieldValue.increment(1),
            'likedBy': FieldValue.arrayUnion([userID]),
          },
        );
      } else {
        await _firestore.updateCommentDoc(
          postID,
          commentID,
          {
            'likes': FieldValue.increment(-1),
            'likedBy': FieldValue.arrayRemove([userID]),
          },
        );
      }
    } on FirebaseException {
      throw CommentFailure.fromUpdateComment();
    }
  }

  // delete comment
  Future<void> deleteComment(String postID, String commentID) async {
    final batch = _firestore.batch();
    final commentRef = _firestore.commentDoc(postID, commentID);
    try {
      final commentDoc = await commentRef.get();
      if (!commentDoc.exists) {
        throw CommentFailure.fromGetComment();
      }
      batch
        ..delete(commentRef)
        ..update(_firestore.postDoc(postID), {
          'comments': FieldValue.increment(-1),
        });
      await batch.commit();
    } on FirebaseException {
      throw CommentFailure.fromDeleteComment();
    }
  }
}
