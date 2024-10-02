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
  Future<int> createPost({
    required Post post,
  }) async {
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
    required int postId,
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
  }) async {
    try {
      final res = await _supabase
          .fromPostsTable()
          .select()
          .range(offset, offset + limit - 1)
          .withConverter(Post.converter);
      return res;
    } catch (e) {
      throw PostFailure.fromGetPost();
    }
  }

  Future<List<Post>> fetchUserPosts({
    required String userId,
    required int limit,
    required int offset,
  }) async {
    try {
      final res = await _supabase
          .fromPostsTable()
          .select()
          .eq(Post.creatorIdConverter, userId)
          .range(offset, offset + limit - 1)
          .withConverter(Post.converter);
      return res;
    } catch (e) {
      throw PostFailure.fromGetPost();
    }
  }

  // Future<List<Post>> fetchUserLikedPosts({
  //   required String userId,
  //   required int limit,
  //   required int offset,
  // }) async {
  //   try {
  //     final res = await _supabase
  //         .fromPostLikesTable()
  //         .select()
  //         .eq(PostLike.userIdConverter, userId)
  //         .range(offset, offset + limit - 1);
  //     final posts = res
  //         .map((post) async => fetchPost(postId: post['post_id'] as int))
  //         .toList();
  //     Post.converter(posts);
  //   } catch (e) {
  //     throw PostFailure.fromGetPost();
  //   }
  // }

  Future<List<Post>> fetchBoardPosts({
    required int boardId,
    required int limit,
    required int offset,
  }) async {
    try {
      final res = await _supabase
          .fromBoardPostsTable()
          .select()
          .eq('board_id', boardId)
          .range(offset, offset + limit - 1)
          .withConverter(Post.converter);
      return res;
    } catch (e) {
      throw PostFailure.fromGetPost();
    }
  }

  Future<int> fetchPostLikes({
    required int postId,
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

extension StreamData on PostRepository {
  Stream<List<Post>> streamUserPosts({
    required String userId,
    required DateTime? lastMarkedTime,
  }) {
    return _supabase
        .fromPostsTable()
        .stream(primaryKey: [Post.idConverter])
        .eq('creator_id', userId)
        .order('created_at')
        .map(Post.converter);
  }

  Stream<List<Post>> streamBoardPosts({
    required int boardId,
  }) {
    return _supabase
        .fromBoardPostsTable()
        .stream(primaryKey: [Post.idConverter])
        .eq('board_id', boardId)
        .order('created_at')
        .map(Post.converter);
  }
}

extension Update on PostRepository {
  // update specific user profile field
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
      throw PostFailure.fromUpdatePost();
    }
  }
}

extension Delete on PostRepository {
  Future<void> deletePost({
    required int postId,
  }) async {
    try {
      await _supabase.fromPostsTable().delete().eq(Post.idConverter, postId);
    } catch (e) {
      throw PostFailure.fromDeletePost();
    }
  }

  Future<void> removeLike({
    required int postId,
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
