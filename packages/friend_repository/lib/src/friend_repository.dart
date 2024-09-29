import 'package:api_client/api_client.dart';
import 'package:friend_repository/src/failures.dart';
import 'package:friend_repository/src/models/models.dart';

class FriendRepository {
  FriendRepository({
    SupabaseClient? supabase,
  }) : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;
}

extension Create on FriendRepository {
  Future<void> sendFriendRequest(String recipientId) async {
    try {
      final data = FriendRequest.insert(
        senderId: _supabase.auth.currentUser!.id,
        recipientId: recipientId,
      );
      await _supabase.from('friend_requests').insert(data);
    } catch (e) {
      throw FriendFailure.fromCreateFriend();
    }
  }

  Future<void> addFriend(String otherUserID) async {
    try {
      final data = Friend.insert(
        userA: _supabase.auth.currentUser!.id,
        userB: otherUserID,
      );
      await _supabase.from('friends').insert(data);
      await removeFriendRequest(otherUserID);
    } catch (e) {
      throw FriendFailure.fromCreateFriend();
    }
  }
}

extension Read on FriendRepository {
  Future<int> fetchFriendCount(String userId) async {
    try {
      final friends = await _supabase
          .from('friends')
          .select()
          .eq(Friend.userAIdConverter, userId)
          .or('${Friend.userBIdConverter}.eq.$userId')
          .count(CountOption.exact);
      return friends.count;
    } catch (e) {
      throw FriendFailure.fromGetFriend();
    }
  }

  Future<bool> areFriends(String userAId, String userBId) async {
    try {
      final friendship = await _supabase.from('friends').select().match({
        Friend.userAIdConverter: userAId,
        Friend.userBIdConverter: userBId,
      }).maybeSingle();

      return friendship != null;
    } catch (e) {
      throw FriendFailure.fromGetFriend();
    }
  }

  Future<bool?> isRecipient(String userId) async {
    final currentUser = _supabase.auth.currentUser!.id;
    try {
      final request = await _supabase
          .from('friend_requests')
          .select()
          .match({
            FriendRequest.senderIdConverter: currentUser,
            FriendRequest.recipientIdConverter: userId,
          })
          .or('${FriendRequest.senderIdConverter}.eq$userId.and.${FriendRequest.recipientIdConverter}.eq.$currentUser')
          .maybeSingle();
      if (request == null) return null;
      return FriendRequest.fromJson(request).senderId == currentUser;
    } catch (e) {
      throw FriendFailure.fromGetFriend();
    }
  }

  Future<List<String>> fetchFriends(String userId) async {
    try {
      final friendships = await _supabase
          .from('friends')
          .select()
          .eq(Friend.userAIdConverter, userId)
          .or('${Friend.userBIdConverter}.eq.$userId')
          .withConverter(Friend.converter);
      final friends = friendships.map((friendship) {
        return userId == friendship.userA ? friendship.userB : friendship.userA;
      }).toList();
      return friends;
    } catch (e) {
      throw FriendFailure.fromGetFriend();
    }
  }

  Future<List<String>> fetchPendingRequests(String userId) async {
    try {
      final friendRequests = await _supabase
          .from('friend_requests')
          .select(
              '${FriendRequest.senderIdConverter}, ${FriendRequest.recipientIdConverter}')
          .eq(FriendRequest.recipientIdConverter, userId)
          .withConverter(FriendRequest.converter);
      final senders =
          friendRequests.map((request) => request.senderId).toList();
      return senders;
    } catch (e) {
      throw FriendFailure.fromGetFriend();
    }
  }
}

extension Update on FriendRepository {}

extension Delete on FriendRepository {
  Future<void> removeFriendRequest(String otherUserID) async {
    try {
      await _supabase.from('friend_requests').delete().match({
        FriendRequest.senderIdConverter: _supabase.auth.currentUser!.id,
        FriendRequest.recipientIdConverter: otherUserID,
      }).or(
          '${FriendRequest.recipientIdConverter}.eq.${_supabase.auth.currentUser!.id}.and.${FriendRequest.senderIdConverter}.eq.$otherUserID');
    } catch (e) {
      throw FriendFailure.fromDeleteFriend();
    }
  }

  Future<void> removeFriend(String otherUserID) async {
    try {
      await _supabase.from('friends').delete().match({
        Friend.userAIdConverter: _supabase.auth.currentUser!.id,
        Friend.userBIdConverter: otherUserID,
      }).or(
          '${Friend.userBIdConverter}.eq.${_supabase.auth.currentUser!.id}.and.${Friend.userAIdConverter}.eq.$otherUserID');
    } catch (e) {
      throw FriendFailure.fromDeleteFriend();
    }
  }
}
