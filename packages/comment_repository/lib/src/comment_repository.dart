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
  Future<void> createComment({
    required int postId,
    required String postCreatorId,
    required String senderId,
    required String message,
  }) async {
    try {
      final data = Comment.insert(
        postId: postId,
        postCreatorId: postCreatorId,
        senderId: senderId,
        message: message,
      );
      await _supabase.fromCommentsTable().insert(data);
    } catch (e) {
      throw CommentFailure.fromCreate();
    }
  }

  Future<void> likeComment({
    required CommentLike like,
  }) async {
    try {
      await _supabase.fromCommentLikesTable().insert(like.toJson());
    } catch (e) {
      throw CommentFailure.fromAdd();
    }
  }
}

extension Read on CommentRepository {
  Future<Comment> fetchComment({required int commentId}) async {
    try {
      return await _supabase
          .fromCommentsTable()
          .select()
          .eq(Comment.idConverter, commentId)
          .maybeSingle()
          .withConverter(
            (data) =>
                data == null ? Comment.empty : Comment.converterSingle(data),
          );
    } catch (e) {
      throw CommentFailure.fromGet();
    }
  }

  Future<bool> hasUserLikedComment({required String userId}) async {
    try {
      final res = await _supabase
          .fromCommentLikesTable()
          .select()
          .eq(CommentLike.userIdConverter, userId)
          .maybeSingle();
      return res != null;
    } catch (e) {
      throw CommentFailure.fromGet();
    }
  }

  Future<List<Comment>> fetchComments({
    required int postId,
    required int limit,
    required int offset,
  }) async {
    try {
      return await _supabase
          .fromCommentsTable()
          .select()
          .eq(Comment.postIdConverter, postId)
          .range(offset, offset + limit - 1)
          .withConverter(Comment.converter);
    } catch (e) {
      throw CommentFailure.fromGet();
    }
  }

  Future<int> fetchCommentLikes({required int commentId}) async {
    try {
      final likes = await _supabase
          .fromCommentLikesTable()
          .select()
          .eq(CommentLike.commentIdConverter, commentId)
          .count(CountOption.exact);
      return likes.count;
    } catch (e) {
      throw CommentFailure.fromGet();
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
      throw CommentFailure.fromGet();
    }
  }
}

extension StreamComments on CommentRepository {
  Stream<List<Comment>> streamComments({required int postId}) {
    try {
      return _supabase
          .fromCommentsTable()
          .stream(primaryKey: [Comment.idConverter])
          .eq(Comment.postIdConverter, postId)
          .order('created_at')
          .map(Comment.converter);
    } catch (e) {
      throw CommentFailure.fromStream();
    }
  }
}

extension Delete on CommentRepository {
  Future<void> deleteComment({required int commentId}) async {
    try {
      await _supabase
          .fromCommentsTable()
          .delete()
          .eq(Comment.idConverter, commentId);
    } catch (e) {
      throw CommentFailure.fromDelete();
    }
  }

  Future<void> removeLike({required int commentId}) async {
    try {
      await _supabase
          .fromCommentLikesTable()
          .delete()
          .eq(CommentLike.commentIdConverter, commentId);
    } catch (e) {
      throw CommentFailure.fromDelete();
    }
  }
}
