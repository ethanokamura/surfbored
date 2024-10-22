import 'package:api_client/api_client.dart';
import 'package:post_repository/src/failures.dart';
import 'package:post_repository/src/models/post.dart';
import 'package:post_repository/src/models/post_like.dart';

/// Repository class for handling post-related operations
class PostRepository {
  /// Constructor for PostRepository
  /// If [supabase] is not provided, it uses the default Supabase instance.
  PostRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;
}

extension Create on PostRepository {
  /// Creates a new post in the database
  /// Returns the ID of the newly created post
  Future<int> createPost({required Post post}) async {
    try {
      final res = await _supabase
          .fromPostsTable()
          .insert(post.toJson())
          .select('id')
          .single();
      return res['id'] as int;
    } catch (e) {
      throw PostFailure.fromCreate();
    }
  }

  /// Creates a new post and returns its ID.
  Future<int> uploadPost({required Map<String, dynamic> data}) async {
    try {
      final res =
          await _supabase.fromPostsTable().insert(data).select('id').single();
      return res['id'] as int;
    } catch (e) {
      throw PostFailure.fromCreate();
    }
  }

  /// Adds a like to a post
  Future<void> likePost({required PostLike like}) async {
    try {
      await _supabase.fromPostLikesTable().insert(like.toJson());
    } catch (e) {
      throw PostFailure.fromAdd();
    }
  }
}

extension Read on PostRepository {
  /// Fetches a single post by its ID
  Future<Post> fetchPost({required int postId}) async {
    try {
      return await _supabase
          .fromPostsTable()
          .select()
          .eq(Post.idConverter, postId)
          .maybeSingle()
          .withConverter(
            (data) => data == null ? Post.empty : Post.converterSingle(data),
          );
    } catch (e) {
      throw PostFailure.fromGet();
    }
  }

  /// Searches for posts based on a query string
  Future<List<Post>> searchPosts({
    required String query,
    required int offset,
    required int limit,
  }) async {
    try {
      return await _supabase
          .fromPostsTable()
          .select()
          .textSearch(Post.postSearchQuery, query)
          .range(offset, offset + limit - 1)
          .withConverter(Post.converter);
    } catch (e) {
      throw PostFailure.fromGet();
    }
  }

  /// Checks if a user has liked a specific post
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
      throw PostFailure.fromGet();
    }
  }

  /// Fetches all posts with pagination
  Future<List<Post>> fetchAllPosts({
    required int limit,
    required int offset,
  }) async {
    try {
      return await _supabase
          .fromPostsTable()
          .select()
          .range(offset, offset + limit - 1)
          .order('created_at')
          .withConverter(Post.converter);
    } catch (e) {
      throw PostFailure.fromGet();
    }
  }

  /// Fetches posts by a specific user
  Future<List<Post>> fetchUserPosts({
    required String userId,
    required int limit,
    required int offset,
  }) async {
    try {
      return await _supabase
          .fromPostsTable()
          .select()
          .eq(Post.creatorIdConverter, userId)
          .range(offset, offset + limit - 1)
          .order('created_at')
          .withConverter(Post.converter);
    } catch (e) {
      throw PostFailure.fromGet();
    }
  }

  /// Fetches posts for a specific board
  Future<List<Post>> fetchBoardPosts({
    required int boardId,
    required int limit,
    required int offset,
  }) async {
    try {
      final res = await _supabase
          .fromBoardPostsTable()
          .select('post_id')
          .eq('board_id', boardId)
          .range(offset, offset + limit - 1)
          .order('created_at');

      final postIds =
          res.map<int>((result) => result['post_id'] as int).toList();

      if (postIds.isEmpty) return [];

      final postsResponse = await _supabase
          .fromPostsTable()
          .select()
          .inFilter(Post.idConverter, postIds);

      final posts = Post.converter(postsResponse);

      return posts;
    } catch (e) {
      throw PostFailure.fromGet();
    }
  }

  /// Fetches the number of likes for a specific post
  Future<int> fetchPostLikes({required int postId}) async {
    try {
      final likes = await _supabase
          .fromPostLikesTable()
          .select()
          .eq(PostLike.postIdConverter, postId)
          .count(CountOption.exact);
      return likes.count;
    } catch (e) {
      throw PostFailure.fromGet();
    }
  }
}

extension StreamData on PostRepository {
  /// Streams posts by a specific user
  Stream<List<Post>> streamUserPosts({
    required String userId,
    required DateTime? lastMarkedTime,
  }) {
    try {
      return _supabase
          .fromPostsTable()
          .stream(primaryKey: [Post.idConverter])
          .eq('creator_id', userId)
          .order('created_at')
          .map(Post.converter);
    } catch (e) {
      throw PostFailure.fromStream();
    }
  }

  /// Streams posts for a specific board
  Stream<List<Post>> streamBoardPosts({required int boardId}) {
    try {
      return _supabase
          .fromBoardPostsTable()
          .stream(primaryKey: [Post.idConverter])
          .eq('board_id', boardId)
          .order('created_at')
          .map(Post.converter);
    } catch (e) {
      throw PostFailure.fromStream();
    }
  }
}

extension Update on PostRepository {
  /// Updates a specific field of a post
  Future<void> updatePost({
    required String field,
    required int postId,
    required dynamic data,
  }) async {
    try {
      await _supabase
          .fromPostsTable()
          .update({field: data}).eq(Post.idConverter, postId);
    } catch (e) {
      PostFailure.fromUpdate();
    }
  }
}

extension Delete on PostRepository {
  /// Deletes a post by its ID
  Future<void> deletePost({required int postId}) async {
    try {
      await _supabase.fromPostsTable().delete().eq(Post.idConverter, postId);
    } catch (e) {
      PostFailure.fromDelete();
    }
  }

  /// Removes a like from a post
  Future<void> removeLike({
    required int postId,
    required String userId,
  }) async {
    try {
      await _supabase.fromPostLikesTable().delete().match({
        PostLike.postIdConverter: postId,
        PostLike.userIdConverter: userId,
      });
    } catch (e) {
      throw PostFailure.fromDelete();
    }
  }
}
