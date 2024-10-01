import 'package:api_client/api_client.dart';
import 'package:post_repository/src/failures.dart';
import 'package:post_repository/src/models/post.dart';

class PostRepository {
  PostRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;
}

extension Create on PostRepository {
  Future<void> createPost(Post post) async {
    try {
      await _supabase.from('posts').insert(post.toJson());
    } catch (e) {
      throw PostFailure.fromCreatePost();
    }
  }
}

extension Read on PostRepository {
  Future<Post> fetchPost(String postId) async {
    try {
      final res = await _supabase
          .from('users')
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
}

extension Update on PostRepository {}

extension Delete on PostRepository {}
