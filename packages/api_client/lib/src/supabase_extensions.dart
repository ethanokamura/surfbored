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
  SupabaseQueryBuilder fromUserAccountTable() => from('user_account');
  SupabaseQueryBuilder fromUserTagsTable() => from('user_tags');
  SupabaseQueryBuilder fromUsersTable() => from('users');

  /// Upload A File
  /// [collection] the collection the file is stored in
  /// [file] the file that needs to be uploaded
  Future<String> uploadFile({
    required String collection,
    required String path,
    required Uint8List file,
  }) async {
    try {
      await Supabase.instance.client.storage.from(collection).uploadBinary(
            path,
            file,
          );
      return Supabase.instance.client.storage
          .from(collection)
          .getPublicUrl(path);
    } catch (e) {
      throw Exception('Error uploading file $e');
    }
  }
}
