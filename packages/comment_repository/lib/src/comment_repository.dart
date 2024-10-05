import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:comment_repository/src/failures.dart';
import 'package:comment_repository/src/models/comment.dart';
import 'package:comment_repository/src/models/comment_like.dart';

class CommentRepository {
  CommentRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;
}

extension Create on CommentRepository {
  Future<void> createComment({required Comment comment}) async =>
      _supabase.fromCommentsTable().insert(comment.toJson());

  Future<void> likeComment({
    required CommentLike like,
  }) async =>
      await _supabase.fromCommentLikesTable().insert(like.toJson());
}

extension Read on CommentRepository {
  Future<Comment> fetchComment({required int commentId}) async => _supabase
      .fromCommentsTable()
      .select()
      .eq(Comment.idConverter, commentId)
      .maybeSingle()
      .withConverter(
        (data) => data == null ? Comment.empty : Comment.converterSingle(data),
      );

  Future<bool> hasUserLikedComment({required String userId}) async {
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
    required int postId,
    required int limit,
    required int offset,
  }) async =>
      _supabase
          .fromCommentsTable()
          .select()
          .eq(Comment.postIdConverter, postId)
          .range(offset, offset + limit - 1)
          .withConverter(Comment.converter);

  Future<int> fetchCommentLikes({required int commentId}) async {
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

  Future<int> fetchTotalComments({required int postId}) async {
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

extension StreamComments on CommentRepository {
  Stream<List<Comment>> streamComments({required int postId}) => _supabase
      .fromCommentsTable()
      .stream(primaryKey: [Comment.idConverter])
      .eq(Comment.postIdConverter, postId)
      .order('created_at')
      .map(Comment.converter);
}

extension Delete on CommentRepository {
  Future<void> deleteComment({required int commentId}) async =>
      _supabase.fromPostsTable().delete().eq(Comment.idConverter, commentId);

  Future<void> removeLike({required int commentId}) async => _supabase
      .fromCommentLikesTable()
      .delete()
      .eq(CommentLike.commentIdConverter, commentId);
}
