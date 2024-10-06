import 'package:api_client/api_client.dart';
import 'package:tag_repository/tag_repository.dart';

class TagRepository {
  TagRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;
}

extension Create on TagRepository {
  Future<void> createUserTag({
    required String tagName,
    required int id,
  }) async =>
      _createTag(tagName: tagName, id: id, type: 'user');

  Future<void> createPostTag({
    required String tagName,
    required int id,
  }) async =>
      _createTag(tagName: tagName, id: id, type: 'post');
}

extension Read on TagRepository {
  Future<List<String>> fetchUserTags({required String id}) async {
    try {
      final response = await _supabase
          .fromUserTagsTable()
          .select('tags(name)')
          .eq('user_id', id);
      if (response.isEmpty) return [];
      return response
          .map<String>((row) => (row as Map<String, String>)['name']!)
          .toList();
    } catch (e) {
      throw TagFailure.fromGet();
    }
  }

  Future<List<String>> fetchPostTags({required int id}) async {
    try {
      final response = await _supabase
          .fromPostTagsTable()
          .select('tags(name)')
          .eq('post_id', id);
      if (response.isEmpty) return [];
      return response
          .map<String>((row) => (row as Map<String, String>)['name']!)
          .toList();
    } catch (e) {
      throw TagFailure.fromGet();
    }
  }
}

extension Update on TagRepository {
  Future<void> updateUserTags({
    required String userId,
    required List<String> tags,
  }) async {
    try {
      final tagIds = await _getTagIds(tags: tags);
      await _supabase.fromUserTagsTable().delete().match({'user_id': userId});
      await _supabase.fromUserTagsTable().insert(
            tagIds
                .map((tagId) => {'user_id': userId, 'tag_id': tagId})
                .toList(),
          );
    } catch (e) {
      throw TagFailure.fromUpdate();
    }
  }

  Future<void> updatePostTags({
    required int id,
    required List<String> tags,
  }) async {
    try {
      final tagIds = await _getTagIds(tags: tags);
      await _supabase.fromPostTagsTable().delete().match({'post_id': id});
      await _supabase.fromPostTagsTable().insert(
            tagIds.map((tagId) => {'post_id': id, 'tag_id': tagId}).toList(),
          );
    } catch (e) {
      throw TagFailure.fromUpdate();
    }
  }
}

extension Delete on TagRepository {
  // Delete a tag by its ID
  Future<void> deleteTag({required String tagId}) async {
    try {
      await _supabase.fromTagsTable().delete().eq('id', tagId);
    } catch (e) {
      throw TagFailure.fromDelete();
    }
  }
}

extension Private on TagRepository {
  Future<void> _createTag({
    required String tagName,
    required int id,
    required String type,
  }) async {
    final tagId = await _getOrCreateTagId(tagName: tagName);
    try {
      await _supabase.from('${type}_tags').insert({
        'name': tagId,
        '${type}_tags': id,
      });
    } catch (e) {
      throw TagFailure.fromCreate();
    }
  }

  Future<int> _getOrCreateTagId({required String tagName}) async {
    try {
      final existingTag = await _supabase
          .fromTagsTable()
          .select('id')
          .eq('name', tagName)
          .maybeSingle();

      if (existingTag == null || existingTag.isEmpty) {
        return _createNewTag(tagName: tagName);
      }
      return existingTag['id'] as int;
    } catch (e) {
      throw TagFailure.fromCreate();
    }
  }

  Future<int> _createNewTag({required String tagName}) async {
    try {
      final newTag = await _supabase
          .fromTagsTable()
          .insert({'name': tagName})
          .select()
          .single();
      if (newTag.isEmpty) {
        throw TagFailure.fromCreate();
      }
      return newTag['id'] as int;
    } catch (e) {
      throw TagFailure.fromGet();
    }
  }

  Future<List<int>> _getTagIds({required List<String> tags}) async {
    // Step 1: Upsert the new tags into the tags table
    final upsertTagsResponse = await _supabase
        .fromTagsTable()
        .upsert(
          tags.map((tagName) => {'name': tagName}).toList(),
          onConflict: 'name',
        )
        .select();

    if (upsertTagsResponse.isEmpty) {
      throw TagFailure.fromUpdate();
    }

    // Extract tag IDs from the response
    final tagIds = upsertTagsResponse.map((tag) => tag['id'] as int).toList();

    return tagIds;
  }
}
