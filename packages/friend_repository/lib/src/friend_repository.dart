import 'package:api_client/api_client.dart';
import 'package:friend_repository/src/failures.dart';

class FriendRepository {
  FriendRepository({
    SupabaseClient? supabase,
  }) : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;
}

extension Create on FriendRepository {
  Future<void> sendFriendRequest(String otherUserID) async {
    try {
      await _supabase.from('friend_requests').insert({
        'sender_id': _supabase.auth.currentUser!.id,
        'recipient_id': otherUserID,
      });
    } catch (e) {
      throw FriendFailure.fromCreateFriend();
    }
  }

  Future<void> addFriend(String otherUserID) async {
    try {
      await _supabase.from('friends').insert({
        'user_a_id': _supabase.auth.currentUser!.id,
        'user_b_id': otherUserID,
      });
      await removeFriendRequest(otherUserID);
    } catch (e) {
      throw FriendFailure.fromCreateFriend();
    }
  }
}

extension Read on FriendRepository {
  Future<bool> areFriends(String userAId, String userBId) async {
    final response = await _supabase
        .from('friends')
        .select()
        .eq('user_a_id', userAId)
        .eq('user_b_id', userBId)
        .maybeSingle();

    return response != null; // Check if response is not null
  }

  Future<List<dynamic>> fetchFriends(String userId) async {
    final response = await _supabase
        .from('friends')
        .select()
        .or('user_a_id.eq.$userId,user_b_id.eq.$userId');

    return response.isNotEmpty
        ? response
        : []; // Check if response is not empty
  }

  Future<List<Map<String, dynamic>>> fetchPendingRequests(String userId) async {
    final response = await _supabase
        .from('friend_requests')
        .select('sender_id, recipient_id')
        .eq('recipient_id', userId);

    return response.isNotEmpty
        ? response
        : []; // Check if response is not empty
  }
}

extension Update on FriendRepository {}

extension Delete on FriendRepository {
  Future<void> removeFriendRequest(String otherUserID) async {
    try {
      await _supabase.from('friend_requests').delete().or(
          'sender_id.eq.${_supabase.auth.currentUser!.id}.and.recipient_id.eq.$otherUserID,recipient_id.eq.${_supabase.auth.currentUser!.id}.and.sender_id.eq.$otherUserID');
    } catch (e) {
      throw FriendFailure.fromDeleteFriend();
    }
  }

  Future<void> removeFriend(String otherUserID) async {
    try {
      await _supabase.from('friends').delete().or(
          'user_a_id.eq.${_supabase.auth.currentUser!.id}.and.user_b_id.eq.$otherUserID,user_b_id.eq.${_supabase.auth.currentUser!.id}.and.user_a_id.eq.$otherUserID');
    } catch (e) {
      throw FriendFailure.fromDeleteFriend();
    }
  }
}
