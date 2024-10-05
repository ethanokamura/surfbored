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
  Future<int> createPost({required Post post}) async {
    try {
      final res = await _supabase
          .fromPostsTable()
          .insert(post.toJson())
          .select('id')
          .single();
      return res['id'] as int;
    } catch (e) {
      throw PostFailure.fromCreatePost();
    }
  }

  Future<List<Post>> searchPosts({
    required String query,
    required int offset,
    required int limit,
  }) async =>
      _supabase
          .fromPostsTable()
          .select()
          .textSearch(Post.postSearchQuery, query)
          .range(offset, offset + limit - 1)
          .withConverter(Post.converter);

  Future<void> likePost({required PostLike like}) async =>
      _supabase.fromPostLikesTable().insert(like.toJson());
}

extension Read on PostRepository {
  Future<Post> fetchPost({required int postId}) async => _supabase
      .fromPostsTable()
      .select()
      .eq(Post.idConverter, postId)
      .maybeSingle()
      .withConverter(
        (data) => data == null ? Post.empty : Post.converterSingle(data),
      );

  Future<bool> hasUserLikedPost({
    required int postId,
    required String userId,
  }) async {
    try {
      final res = await _supabase.fromPostLikesTable().select().match({
        PostLike.userIdConverter: postId,
        PostLike.postIdConverter: userId,
      }).maybeSingle();
      return res != null;
    } catch (e) {
      throw PostFailure.fromGetPost();
    }
  }

  Future<List<Post>> fetchAllPosts({
    required int limit,
    required int offset,
  }) async =>
      _supabase
          .fromPostsTable()
          .select()
          .range(offset, offset + limit - 1)
          .withConverter(Post.converter);

  Future<List<Post>> fetchUserPosts({
    required String userId,
    required int limit,
    required int offset,
  }) async =>
      _supabase
          .fromPostsTable()
          .select()
          .eq(Post.creatorIdConverter, userId)
          .range(offset, offset + limit - 1)
          .withConverter(Post.converter);

  // Future<List<Post>> fetchUserLikedPosts({
  //   required String userId,
  //   required int limit,
  //   required int offset,
  // }) async => _supabase
  //         .fromPostLikesTable()
  //         .select()
  //         .eq(PostLike.userIdConverter, userId)
  //         .range(offset, offset + limit - 1);
  //         .withConverter(Post.converter);

  Future<List<Post>> fetchBoardPosts({
    required int boardId,
    required int limit,
    required int offset,
  }) async =>
      _supabase
          .fromBoardPostsTable()
          .select()
          .eq('board_id', boardId)
          .range(offset, offset + limit - 1)
          .withConverter(Post.converter);

  Future<int> fetchPostLikes({required int postId}) async {
    try {
      final likes = await _supabase
          .fromPostLikesTable()
          .select()
          .eq(PostLike.postIdConverter, postId)
          .count(CountOption.exact);
      return likes.count;
    } catch (e) {
      throw PostFailure.fromGetPost();
    }
  }
}

extension StreamData on PostRepository {
  Stream<List<Post>> streamUserPosts({
    required String userId,
    required DateTime? lastMarkedTime,
  }) =>
      _supabase
          .fromPostsTable()
          .stream(primaryKey: [Post.idConverter])
          .eq('creator_id', userId)
          .order('created_at')
          .map(Post.converter);

  Stream<List<Post>> streamBoardPosts({required int boardId}) => _supabase
      .fromBoardPostsTable()
      .stream(primaryKey: [Post.idConverter])
      .eq('board_id', boardId)
      .order('created_at')
      .map(Post.converter);
}

extension Update on PostRepository {
  // update specific user profile field
  Future<void> updatePost({
    required String field,
    required int postId,
    required dynamic data,
  }) async =>
      _supabase
          .fromPostsTable()
          .update({field: data}).eq(Post.idConverter, postId);
}

extension Delete on PostRepository {
  Future<void> deletePost({required int postId}) async =>
      _supabase.fromPostsTable().delete().eq(Post.idConverter, postId);

  Future<void> removeLike({
    required int postId,
    required String userId,
  }) async =>
      _supabase.fromPostLikesTable().delete().match({
        PostLike.postIdConverter: postId,
        PostLike.userIdConverter: userId,
      });
}
