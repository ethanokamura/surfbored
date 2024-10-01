import 'package:api_client/api_client.dart';
import 'package:post_repository/src/failures.dart';
import 'package:post_repository/src/models/post.dart';
import 'package:post_repository/src/models/post_like.dart';

class PostRepository {
  PostRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;
}

extension Create on PostRepository {
  Future<void> createPost({
    required Post post,
  }) async {
    try {
      await _supabase.fromPostsTable().insert(post.toJson());
    } catch (e) {
      throw PostFailure.fromCreatePost();
    }
  }

  Future<void> likePost({
    required PostLike like,
  }) async {
    try {
      await _supabase.fromPostLikesTable().insert(like.toJson());
    } catch (e) {
      throw PostFailure.fromCreatePost();
    }
  }
}

extension Read on PostRepository {
  Future<Post> fetchPost({
    required String postId,
  }) async {
    try {
      final res = await _supabase
          .fromPostsTable()
          .select()
          .eq(Post.idConverter, postId)
          .maybeSingle()
          .withConverter(
            (data) => data == null ? Post.empty : Post.converterSingle(data),
          );
      return res;
    } catch (e) {
      throw PostFailure.fromGetPost();
    }
  }

  Future<List<Post>> fetchUserPosts({required String userId}) async =>
      _fetchPosts(type: 'user', uuid: userId);

  Future<List<Post>> fetchBoardPosts({required String boardId}) async =>
      _fetchPosts(type: 'board', uuid: boardId);

  Future<int> fetchPostLikes({
    required String postId,
  }) async {
    try {
      final likes = await _supabase
          .fromPostLikesTable()
          .select()
          .eq(Post.idConverter, postId)
          .count(CountOption.exact);
      return likes.count;
    } catch (e) {
      throw PostFailure.fromGetPost();
    }
  }
}

extension Update on PostRepository {
  // update specific user profile field
  Future<void> updatePost({
    required String field,
    required String postId,
    required dynamic data,
  }) async {
    try {
      await _supabase
          .fromPostsTable()
          .update({field: data}).eq(Post.idConverter, postId);
    } catch (e) {
      throw PostFailure.fromUpdatePost();
    }
  }
}

extension Delete on PostRepository {
  Future<void> deletePost({
    required String postId,
  }) async {
    try {
      await _supabase.fromPostsTable().delete().eq(Post.idConverter, postId);
    } catch (e) {
      throw PostFailure.fromDeletePost();
    }
  }

  Future<void> removeLike({
    required String postId,
    required String userId,
  }) async {
    try {
      await _supabase.fromPostLikesTable().delete().match({
        PostLike.userIdConverter: userId,
        PostLike.postIdConverter: postId,
      });
    } catch (e) {
      throw PostFailure.fromDeletePost();
    }
  }
}

extension Private on PostRepository {
  Future<List<Post>> _fetchPosts({
    required String type,
    required String uuid,
  }) async {
    try {
      final res = await _supabase
          .from('${type}_posts')
          .select()
          .eq('${type}_id', uuid)
          .withConverter(Post.converter);
      return res;
    } catch (e) {
      throw PostFailure.fromGetPost();
    }
  }
}
