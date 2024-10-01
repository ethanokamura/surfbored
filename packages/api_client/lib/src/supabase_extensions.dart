import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

extension SupabaseExtensions on SupabaseClient {
  static final ref = Supabase.instance.client.storage;

  // Reference to the supabase tables
  SupabaseQueryBuilder fromBlockedUsersTable() => from('blocked_users');
  SupabaseQueryBuilder fromBoardPostsTable() => from('board_posts');
  SupabaseQueryBuilder fromBoardSavesTable() => from('board_saves');
  SupabaseQueryBuilder fromBoardTagsTable() => from('board_tags');
  SupabaseQueryBuilder fromBoardsTable() => from('boards');
  SupabaseQueryBuilder fromCommentLikesTable() => from('comment_likes');
  SupabaseQueryBuilder fromCommentsTable() => from('comments');
  SupabaseQueryBuilder fromFriendRequestsTable() => from('friend_requests');
  SupabaseQueryBuilder fromFriendsTable() => from('friends');
  SupabaseQueryBuilder fromPostLikesTable() => from('post_likes');
  SupabaseQueryBuilder fromPostTagsTable() => from('post_tags');
  SupabaseQueryBuilder fromPostsTable() => from('posts');
  SupabaseQueryBuilder fromTagsTable() => from('tags');
  SupabaseQueryBuilder fromUserProfilesTable() => from('user_profiles');
  SupabaseQueryBuilder fromUserTagsTable() => from('user_tags');
  SupabaseQueryBuilder fromUsersTable() => from('users');

  /// Upload A File
  /// [collection] the collection the file is stored in
  /// [id] the document id
  /// [file] the file that needs to be uploaded
  Future<String> uploadFile(
    String collection,
    String id,
    Uint8List file,
  ) async {
    // get path
    final path = '/$id/image';
    try {
      await Supabase.instance.client.storage.from(collection).uploadBinary(
            path,
            file,
          );
      return Supabase.instance.client.storage
          .from(collection)
          .getPublicUrl(path);
    } catch (e) {
      throw Exception('Error uploading file');
    }
  }
}
