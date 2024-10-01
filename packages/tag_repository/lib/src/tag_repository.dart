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
}
