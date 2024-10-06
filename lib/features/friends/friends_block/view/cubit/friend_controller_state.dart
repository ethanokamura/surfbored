part of 'friend_controller_cubit.dart';

enum FriendControllerStatus {
  initial,
  loading,
  loaded,
  failure,
  requested,
  recieved,
  friended,
}

final class FriendControllerState extends Equatable {
  const FriendControllerState._({
    this.status = FriendControllerStatus.initial,
    this.failure = FriendFailure.empty,
    this.friends = 0,
  });

  // initial state
  const FriendControllerState.initial() : this._();

  final FriendControllerStatus status;
  final FriendFailure failure;
  final int friends;

  // rebuilds the app when the props change
  @override
  List<Object?> get props => [
        status,
        failure,
        friends,
      ];

  FriendControllerState copyWith({
    FriendControllerStatus? status,
    FriendFailure? failure,
    int? friends,
  }) {
    return FriendControllerState._(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      friends: friends ?? this.friends,
    );
  }
}

extension FriendControllerStateExtensions on FriendControllerState {
  bool get isLoaded => status == FriendControllerStatus.loaded;
  bool get isLoading => status == FriendControllerStatus.loading;
  bool get isFailure => status == FriendControllerStatus.failure;
  bool get isRequested => status == FriendControllerStatus.requested;
  bool get isRecieved => status == FriendControllerStatus.recieved;
  bool get areFriends => status == FriendControllerStatus.friended;
}

extension _FriendControllerStateExtensions on FriendControllerState {
  FriendControllerState fromLoading() =>
      copyWith(status: FriendControllerStatus.loading);
  FriendControllerState fromFailure(FriendFailure failure) =>
      copyWith(failure: failure, status: FriendControllerStatus.failure);
  FriendControllerState fromNoRequest() =>
      copyWith(status: FriendControllerStatus.initial);
  FriendControllerState fromRequestSent() =>
      copyWith(status: FriendControllerStatus.requested);
  FriendControllerState fromRequestRecieved() =>
      copyWith(status: FriendControllerStatus.recieved);
  FriendControllerState fromFriendAccepted() =>
      copyWith(status: FriendControllerStatus.friended);
}
