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
    required String uuid,
  }) async =>
      _createTag(tagName: tagName, uuid: uuid, type: 'user');

  Future<void> createPostTag({
    required String tagName,
    required String uuid,
  }) async =>
      _createTag(tagName: tagName, uuid: uuid, type: 'post');

  Future<void> createBoardTag({
    required String tagName,
    required String uuid,
  }) async =>
      _createTag(tagName: tagName, uuid: uuid, type: 'board');
}

extension Read on TagRepository {
  Future<List<String>> readUserTags({required String uuid}) async =>
      _readTags(type: 'user', uuid: uuid);

  Future<List<String>> readPostTags({required String uuid}) async =>
      _readTags(type: 'post', uuid: uuid);

  Future<List<String>> readBoardTags({required String uuid}) async =>
      _readTags(type: 'board', uuid: uuid);
}

extension Update on TagRepository {
  Future<void> updateUserTags({
    required String userId,
    required List<String> tags,
  }) async =>
      _updateTags(type: 'user', uuid: userId, tags: tags);

  Future<void> updatePostTags({
    required String postId,
    required List<String> tags,
  }) async =>
      _updateTags(type: 'post', uuid: postId, tags: tags);

  Future<void> updateBoardTags({
    required String boardId,
    required List<String> tags,
  }) async =>
      _updateTags(type: 'board', uuid: boardId, tags: tags);
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
    required String uuid,
    required String type,
  }) async {
    final tagId = await _getOrCreateTagId(tagName: tagName);
    try {
      await _supabase.from('${type}_tags').insert({
        'name': tagId,
        '${type}_tags': uuid,
      });
    } catch (e) {
      throw TagFailure.fromCreateTag();
    }
  }

  Future<String> _getOrCreateTagId({required String tagName}) async {
    try {
      final existingTag = await _supabase
          .fromTagsTable()
          .select('id')
          .eq('name', tagName)
          .maybeSingle();

      if (existingTag == null || existingTag.isEmpty) {
        return _createNewTag(tagName: tagName);
      }
      return existingTag['id'] as String;
    } catch (e) {
      throw TagFailure.fromCreateTag();
    }
  }

  Future<String> _createNewTag({required String tagName}) async {
    try {
      final newTag = await _supabase
          .fromTagsTable()
          .insert({'name': tagName})
          .select()
          .single();
      if (newTag.isEmpty) {
        throw TagFailure.fromCreateTag();
      }
      return newTag['id'] as String;
    } catch (e) {
      throw TagFailure.fromGetTag();
    }
  }

  Future<List<String>> _readTags({
    required String type,
    required String uuid,
  }) async {
    try {
      final response = await _supabase
          .from('${type}_tags')
          .select('tags(name)')
          .eq('${type}_id', uuid);
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
    required String uuid,
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
    await _supabase.from('${type}_tags').delete().match({'${type}_id': uuid});

    // Step 3: Insert new tag associations into user_tags
    await _supabase.from('${type}_tags').insert(
          tagIds.map((tagId) => {'${type}_id': uuid, 'tag_id': tagId}).toList(),
        );
  }
}
