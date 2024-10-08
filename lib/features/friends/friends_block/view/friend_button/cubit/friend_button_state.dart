part of 'friend_button_cubit.dart';

enum FriendButtonStatus {
  initial,
  loading,
  loaded,
  failure,
  empty,
}

enum FriendStatus {
  empty,
  requested,
  recieved,
  friends,
}

final class FriendButtonState extends Equatable {
  const FriendButtonState._({
    this.status = FriendButtonStatus.initial,
    this.friendStatus = FriendStatus.empty,
    this.failure = FriendFailure.empty,
  });

  // initial state
  const FriendButtonState.initial() : this._();

  final FriendButtonStatus status;
  final FriendStatus friendStatus;
  final FriendFailure failure;

  // rebuilds the app when the props change
  @override
  List<Object?> get props => [
        status,
        friendStatus,
        failure,
      ];

  FriendButtonState copyWith({
    FriendButtonStatus? status,
    FriendStatus? friendStatus,
    FriendFailure? failure,
  }) {
    return FriendButtonState._(
      status: status ?? this.status,
      friendStatus: friendStatus ?? this.friendStatus,
      failure: failure ?? this.failure,
    );
  }
}

extension FriendButtonStateExtensions on FriendButtonState {
  bool get isLoaded => status == FriendButtonStatus.loaded;
  bool get isLoading => status == FriendButtonStatus.loading;
  bool get isFailure => status == FriendButtonStatus.failure;
  bool get isEmpty => status == FriendButtonStatus.empty;
}

extension _FriendButtonStateExtensions on FriendButtonState {
  FriendButtonState fromLoading() =>
      copyWith(status: FriendButtonStatus.loading);
  FriendButtonState fromFailure(FriendFailure failure) =>
      copyWith(failure: failure, status: FriendButtonStatus.failure);

  FriendButtonState fromRequestSent() => copyWith(
        friendStatus: FriendStatus.requested,
        status: FriendButtonStatus.loaded,
      );
  FriendButtonState fromRequestRecieved() => copyWith(
        friendStatus: FriendStatus.recieved,
        status: FriendButtonStatus.loaded,
      );
  FriendButtonState fromFriendAccepted() => copyWith(
        friendStatus: FriendStatus.friends,
        status: FriendButtonStatus.loaded,
      );
  FriendButtonState fromNoRequest() => copyWith(
        friendStatus: FriendStatus.empty,
        status: FriendButtonStatus.loaded,
      );
}
