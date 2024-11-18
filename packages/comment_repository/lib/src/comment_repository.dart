import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:comment_repository/src/failures.dart';
import 'package:comment_repository/src/models/comment.dart';
import 'package:comment_repository/src/models/comment_like.dart';

/// Repository for managing comment-related operations.
class CommentRepository {
  /// Constructor for CommentRepository.
  /// If [supabase] is not provided, it uses the default Supabase instance.
  CommentRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;
}

extension Create on CommentRepository {
  /// Creates a new comment in the database.
  Future<void> createComment({required Comment comment}) async {
    try {
      await _supabase.fromCommentsTable().insert(comment.toJson());
    } catch (e) {
      throw CommentFailure.fromCreate();
    }
  }

  /// Adds a like to a comment.
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
  /// Fetches a single comment by its ID.
  /// Returns [Comment.empty] if the comment is not found.
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

  /// Checks if a user has liked a specific comment.
  /// Returns `true` if the user has liked the comment, `false` otherwise.
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

  /// Fetches a list of comments for a specific post with pagination.
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
          .order('created_at')
          .range(offset, offset + limit - 1)
          .withConverter(Comment.converter);
    } catch (e) {
      throw CommentFailure.fromGet();
    }
  }

  /// Fetches the number of likes for a specific comment.
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

  /// Fetches the total number of comments for a specific post.
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
  /// Creates a stream of comments for a specific post.
  /// The stream emits updated lists of comments whenever changes occur.
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
  /// Deletes a comment by its ID.
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

  /// Removes a like from a comment.
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
