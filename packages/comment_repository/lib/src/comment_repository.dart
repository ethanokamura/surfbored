import 'package:api_client/api_client.dart';
import 'package:comment_repository/src/failures.dart';
import 'package:comment_repository/src/models/models.dart';

class PostRepository {
  PostRepository({
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
  Future<Comment> readComment(String postID, String commentID) async {
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
    required bool liked,
  }) async {
    try {
      await _firestore.updateCommentDoc(
        postID,
        commentID,
        {'likes': FieldValue.increment(!liked ? 1 : -1)},
      );
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
