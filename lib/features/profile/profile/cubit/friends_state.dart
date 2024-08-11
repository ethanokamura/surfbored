part of 'friends_cubit.dart';

enum FriendStatus {
  initial,
  loading,
  loaded,
  failure,
  requested,
  recieved,
  friended,
}

final class FriendState extends Equatable {
  const FriendState._({
    this.status = FriendStatus.initial,
    this.friends = 0,
  });

  // initial state
  const FriendState.initial() : this._();

  final FriendStatus status;
  final int friends;

  // rebuilds the app when the props change
  @override
  List<Object?> get props => [
        status,
        friends,
      ];

  FriendState copyWith({
    FriendStatus? status,
    int? friends,
  }) {
    return FriendState._(
      status: status ?? this.status,
      friends: friends ?? this.friends,
    );
  }
}

extension FriendStateExtensions on FriendState {
  bool get isLoaded => status == FriendStatus.loaded;
  bool get isLoading => status == FriendStatus.loading;
  bool get isFailure => status == FriendStatus.failure;
  bool get isRequested => status == FriendStatus.requested;
  bool get isRecieved => status == FriendStatus.recieved;
  bool get areFriends => status == FriendStatus.friended;
}

extension _FriendStateExtensions on FriendState {
  FriendState fromLoading() => copyWith(status: FriendStatus.loading);
  FriendState fromFailure() => copyWith(status: FriendStatus.failure);
  FriendState fromNoRequest() => copyWith(status: FriendStatus.initial);
  FriendState fromRequestSent() => copyWith(status: FriendStatus.requested);
  FriendState fromRequestRecieved() => copyWith(status: FriendStatus.recieved);
  FriendState fromFriendAccepted() => copyWith(status: FriendStatus.friended);
}
