import 'package:api_client/api_client.dart';
import 'package:friend_repository/src/failures.dart';
import 'package:friend_repository/src/models/friend.dart';
import 'package:friend_repository/src/models/friend_request.dart';

class FriendRepository {
  FriendRepository({
    SupabaseClient? supabase,
  }) : _supabase = supabase ?? Supabase.instance.client;

  final SupabaseClient _supabase;
}

extension Create on FriendRepository {
  Future<void> sendFriendRequest({
    required String senderId,
    required String recipientId,
  }) async {
    try {
      final data = FriendRequest.insert(
        senderId: senderId,
        recipientId: recipientId,
      );
      await _supabase.fromFriendRequestsTable().insert(data);
    } catch (e) {
      throw FriendFailure.fromCreateFriend();
    }
  }

  Future<void> addFriend({
    required String currentUserId,
    required String otherUserId,
  }) async {
    try {
      final data = Friend.insert(
        userA: currentUserId,
        userB: otherUserId,
      );
      await _supabase.fromFriendsTable().insert(data);
      await removeFriendRequest(
        currentUserId: currentUserId,
        otherUserId: otherUserId,
      );
    } catch (e) {
      throw FriendFailure.fromCreateFriend();
    }
  }
}

extension Read on FriendRepository {
  Future<int> fetchFriendCount({
    required String userId,
  }) async {
    try {
      final friends = await _supabase
          .fromFriendsTable()
          .select()
          .eq(Friend.userAIdConverter, userId)
          .or('${Friend.userBIdConverter}.eq.$userId')
          .count(CountOption.exact);
      return friends.count;
    } catch (e) {
      throw FriendFailure.fromGetFriend();
    }
  }

  Future<bool> areFriends({
    required String userAId,
    required String userBId,
  }) async {
    try {
      final friendship = await _supabase.fromFriendsTable().select().match({
        Friend.userAIdConverter: userAId,
        Friend.userBIdConverter: userBId,
      }).maybeSingle();

      return friendship != null;
    } catch (e) {
      throw FriendFailure.fromGetFriend();
    }
  }

  Future<bool?> isRecipient({
    required String userId,
    required String currentUserId,
  }) async {
    try {
      final request = await _supabase
          .fromFriendRequestsTable()
          .select()
          .match({
            FriendRequest.senderIdConverter: currentUserId,
            FriendRequest.recipientIdConverter: userId,
          })
          .or('${FriendRequest.senderIdConverter}.eq$userId.and.${FriendRequest.recipientIdConverter}.eq.$currentUserId')
          .maybeSingle();
      if (request == null) return null;
      return FriendRequest.fromJson(request).senderId == currentUserId;
    } catch (e) {
      throw FriendFailure.fromGetFriend();
    }
  }

  Future<List<String>> fetchFriends({
    required String userId,
    required int limit,
    required int offset,
  }) async {
    try {
      final friendships = await _supabase
          .fromFriendsTable()
          .select()
          .eq(Friend.userAIdConverter, userId)
          .or('${Friend.userBIdConverter}.eq.$userId')
          .range(offset, offset + limit - 1)
          .withConverter(Friend.converter);
      final friends = friendships.map((friendship) {
        return userId == friendship.userA ? friendship.userB : friendship.userA;
      }).toList();
      return friends;
    } catch (e) {
      throw FriendFailure.fromGetFriend();
    }
  }

  Future<List<String>> fetchPendingRequests({
    required String userId,
    required int limit,
    required int offset,
  }) async {
    try {
      final friendRequests = await _supabase
          .fromFriendRequestsTable()
          .select(
            '${FriendRequest.senderIdConverter}, ${FriendRequest.recipientIdConverter}',
          )
          .eq(FriendRequest.recipientIdConverter, userId)
          .range(offset, offset + limit - 1)
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
  Future<void> removeFriendRequest({
    required String currentUserId,
    required String otherUserId,
  }) async {
    try {
      await _supabase.fromFriendRequestsTable().delete().match({
        FriendRequest.senderIdConverter: currentUserId,
        FriendRequest.recipientIdConverter: otherUserId,
      }).or(
        '${FriendRequest.recipientIdConverter}.eq.$currentUserId.and.${FriendRequest.senderIdConverter}.eq.$otherUserId',
      );
    } catch (e) {
      throw FriendFailure.fromDeleteFriend();
    }
  }

  Future<void> removeFriend({
    required String currentUserId,
    required String otherUserId,
  }) async {
    try {
      await _supabase.fromFriendsTable().delete().match({
        Friend.userAIdConverter: currentUserId,
        Friend.userBIdConverter: otherUserId,
      }).or(
        '${Friend.userBIdConverter}.eq.$currentUserId.and.${Friend.userAIdConverter}.eq.$otherUserId',
      );
    } catch (e) {
      throw FriendFailure.fromDeleteFriend();
    }
  }
}
