part of 'friends_cubit.dart';

enum FriendStatus {
  initial,
  loading,
  loaded,
  failure,
  request,
}

final class FriendState extends Equatable {
  const FriendState._({
    this.status = FriendStatus.initial,
    this.senderID,
    this.areFriends = false,
    this.friends = 0,
  });

  // initial state
  const FriendState.initial() : this._();

  final FriendStatus status;
  final String? senderID;
  final bool areFriends;
  final int friends;

  // rebuilds the app when the props change
  @override
  List<Object?> get props => [
        status,
        senderID,
        areFriends,
        friends,
      ];

  FriendState copyWith({
    FriendStatus? status,
    String? senderID,
    bool? areFriends,
    int? friends,
  }) {
    return FriendState._(
      status: status ?? this.status,
      senderID: senderID ?? this.senderID,
      areFriends: areFriends ?? this.areFriends,
      friends: friends ?? this.friends,
    );
  }
}

extension FriendStateExtensions on FriendState {
  bool get isLoaded => status == FriendStatus.loaded;
  bool get isLoading => status == FriendStatus.loading;
  bool get isFailure => status == FriendStatus.failure;
  bool get isRequested => status == FriendStatus.request;
}

extension _FriendStateExtensions on FriendState {
  FriendState fromLoading() => copyWith(status: FriendStatus.loading);

  FriendState fromFailure() => copyWith(status: FriendStatus.failure);

  FriendState fromFriendsLoaded({required int friends}) =>
      copyWith(status: FriendStatus.loaded, friends: friends);

  FriendState fromRequestLoaded({required String? senderID}) =>
      copyWith(status: FriendStatus.loaded, senderID: senderID);

  FriendState fromFriendSuccess({required bool areFriends}) =>
      copyWith(status: FriendStatus.loaded, areFriends: areFriends);
}
