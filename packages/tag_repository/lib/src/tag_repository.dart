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

  Future<void> createBoardTag({
    required String tagName,
    required int id,
  }) async =>
      _createTag(tagName: tagName, id: id, type: 'board');
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
      throw TagFailure.fromGetTag();
    }
  }

  Future<List<String>> fetchPostTags({required int id}) async =>
      _fetchTags(type: 'post', id: id);

  Future<List<String>> fetchBoardTags({required int id}) async =>
      _fetchTags(type: 'board', id: id);
}

extension Update on TagRepository {
  Future<void> updateUserTags({
    required String userId,
    required List<String> tags,
  }) async {
    // Step 1: Upsert the new tags into the tags table
    final upsertTagsResponse = await _supabase
        .fromTagsTable()
        .upsert(
          tags.map((tagName) => {'name': tagName}).toList(),
          onConflict: 'name',
        )
        .select();

    if (upsertTagsResponse.isEmpty) {
      throw TagFailure.fromUpdateTag();
    }

    // Extract tag IDs from the response
    final tagIds =
        upsertTagsResponse.map((tag) => tag['id']).toList().whereType<String>();

    // Step 2: Clear all existing tag associations for this user
    await _supabase.fromUserTagsTable().delete().match({'user_id': userId});

    // Step 3: Insert new tag associations into user_tags
    await _supabase.fromUserTagsTable().insert(
          tagIds.map((tagId) => {'user_id': userId, 'tag_id': tagId}).toList(),
        );
  }

  Future<void> updatePostTags({
    required int postId,
    required List<String> tags,
  }) async =>
      _updateTags(type: 'post', id: postId, tags: tags);

  Future<void> updateBoardTags({
    required int boardId,
    required List<String> tags,
  }) async =>
      _updateTags(type: 'board', id: boardId, tags: tags);
}

extension Delete on TagRepository {
  // Delete a tag by its ID
  Future<void> deleteTag({required String tagId}) async {
    try {
      await _supabase.fromTagsTable().delete().eq('id', tagId);
    } catch (e) {
      throw TagFailure.fromDeleteTag();
    }
  }
}

// private methods
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
      throw TagFailure.fromCreateTag();
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
      throw TagFailure.fromCreateTag();
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
        throw TagFailure.fromCreateTag();
      }
      return newTag['id'] as int;
    } catch (e) {
      throw TagFailure.fromGetTag();
    }
  }

  Future<List<String>> _fetchTags({
    required String type,
    required int id,
  }) async {
    try {
      final response = await _supabase
          .from('${type}_tags')
          .select('tags(name)')
          .eq('${type}_id', id);
      if (response.isEmpty) return [];
      return response
          .map<String>((row) => (row as Map<String, String>)['name']!)
          .toList();
    } catch (e) {
      throw TagFailure.fromGetTag();
    }
  }

  Future<void> _updateTags({
    required String type,
    required int id,
    required List<String> tags,
  }) async {
    // Step 1: Upsert the new tags into the tags table
    final upsertTagsResponse = await _supabase
        .fromTagsTable()
        .upsert(
          tags.map((tagName) => {'name': tagName}).toList(),
          onConflict: 'name',
        )
        .select();

    if (upsertTagsResponse.isEmpty) {
      throw TagFailure.fromUpdateTag();
    }

    // Extract tag IDs from the response
    final tagIds =
        upsertTagsResponse.map((tag) => tag['id']).toList().whereType<String>();

    // Step 2: Clear all existing tag associations for this user
    await _supabase.from('${type}_tags').delete().match({'${type}_id': id});

    // Step 3: Insert new tag associations into user_tags
    await _supabase.from('${type}_tags').insert(
          tagIds.map((tagId) => {'${type}_id': id, 'tag_id': tagId}).toList(),
        );
  }
}
