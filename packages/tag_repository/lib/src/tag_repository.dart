import 'package:api_client/api_client.dart';

class TagRepository {
  TagRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  // Create a new tag and associate it with a user, post, or board
  Future<void> createTag(
      String tagName, String userId, String postId, String boardId) async {
    final response = await _supabase.from('tags').insert({
      'name': tagName,
      'user_id': userId,
      'post_id': postId,
      'board_id': boardId,
    }).execute();

    if (response.error != null) {
      throw Exception('Failed to create tag: ${response.error!.message}');
    }
  }

  // Read all tags associated with a specific user
  Future<List<Map<String, dynamic>>> readUserTags(String userId) async {
    final response =
        await _supabase.from('tags').select().eq('user_id', userId).execute();

    if (response.error != null) {
      throw Exception('Failed to read user tags: ${response.error!.message}');
    }

    return response.data as List<Map<String, dynamic>>;
  }

  // Read all tags associated with a specific post
  Future<List<Map<String, dynamic>>> readPostTags(String postId) async {
    final response =
        await _supabase.from('tags').select().eq('post_id', postId).execute();

    if (response.error != null) {
      throw Exception('Failed to read post tags: ${response.error!.message}');
    }

    return response.data as List<Map<String, dynamic>>;
  }

  // Read all tags associated with a specific board
  Future<List<Map<String, dynamic>>> readBoardTags(String boardId) async {
    final response =
        await _supabase.from('tags').select().eq('board_id', boardId).execute();

    if (response.error != null) {
      throw Exception('Failed to read board tags: ${response.error!.message}');
    }

    return response.data as List<Map<String, dynamic>>;
  }

  // Delete a tag by its ID
  Future<void> deleteTag(String tagId) async {
    final response =
        await _supabase.from('tags').delete().eq('id', tagId).execute();

    if (response.error != null) {
      throw Exception('Failed to delete tag: ${response.error!.message}');
    }
  }
}
