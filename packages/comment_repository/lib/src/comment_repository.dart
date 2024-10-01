import 'package:api_client/api_client.dart';
import 'package:comment_repository/src/failures.dart';
import 'package:comment_repository/src/models/comment.dart';
import 'package:comment_repository/src/models/comment_like.dart';

class CommentRepository {
  CommentRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;
}

extension Create on CommentRepository {
  Future<void> createComment({
    required Comment comment,
  }) async {
    try {
      await _supabase.fromCommentsTable().insert(comment.toJson());
    } catch (e) {
      throw CommentFailure.fromCreateComment();
    }
  }

  Future<void> likeComment({
    required CommentLike like,
  }) async {
    try {
      await _supabase.fromCommentLikesTable().insert(like.toJson());
    } catch (e) {
      throw CommentFailure.fromCreateComment();
    }
  }
}

extension Read on CommentRepository {
  Future<Comment> fetchComment({
    required String commentId,
  }) async {
    try {
      final res = await _supabase
          .fromCommentsTable()
          .select()
          .eq(Comment.idConverter, commentId)
          .maybeSingle()
          .withConverter(
            (data) =>
                data == null ? Comment.empty : Comment.converterSingle(data),
          );
      return res;
    } catch (e) {
      throw CommentFailure.fromGetComment();
    }
  }

  Future<bool> hasUserLikedComment({
    required String userId,
  }) async {
    try {
      final res = await _supabase
          .fromCommentLikesTable()
          .select()
          .eq(CommentLike.userIdConverter, userId)
          .maybeSingle();
      return res != null;
    } catch (e) {
      throw CommentFailure.fromGetComment();
    }
  }

  Future<List<Comment>> fetchComments({
    required String postId,
  }) async {
    try {
      final res = await _supabase
          .fromCommentsTable()
          .select()
          .eq(Comment.postIdConverter, postId)
          .withConverter(Comment.converter);
      return res;
    } catch (e) {
      throw CommentFailure.fromGetComment();
    }
  }

  Future<int> fetchCommentLikes({
    required String commentId,
  }) async {
    try {
      final likes = await _supabase
          .fromCommentLikesTable()
          .select()
          .eq(CommentLike.commentIdConverter, commentId)
          .count(CountOption.exact);
      return likes.count;
    } catch (e) {
      throw CommentFailure.fromGetComment();
    }
  }

  Future<int> fetchTotalComments({
    required String postId,
  }) async {
    try {
      final comments = await _supabase
          .fromCommentsTable()
          .select()
          .eq(Comment.postIdConverter, postId)
          .count(CountOption.exact);
      return comments.count;
    } catch (e) {
      throw CommentFailure.fromGetComment();
    }
  }
}

extension Delete on CommentRepository {
  Future<void> deleteComment({
    required String commentId,
  }) async {
    try {
      await _supabase
          .fromPostsTable()
          .delete()
          .eq(Comment.idConverter, commentId);
    } catch (e) {
      throw CommentFailure.fromDeleteComment();
    }
  }

  Future<void> removeLike({
    required String commentId,
  }) async {
    try {
      await _supabase
          .fromCommentLikesTable()
          .delete()
          .eq(CommentLike.commentIdConverter, commentId);
    } catch (e) {
      throw CommentFailure.fromDeleteComment();
    }
  }
}
