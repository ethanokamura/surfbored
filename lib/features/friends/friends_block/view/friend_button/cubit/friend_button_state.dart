part of 'friend_button_cubit.dart';

/// Represents the different states the friend button can be in.
enum FriendButtonStatus {
  initial,
  loading,
  loaded,
  failure,
  empty,
}

/// Represents the different states a friend operation can be in.
enum FriendStatus {
  empty,
  requested,
  recieved,
  friends,
}

/// Represents the state of friend button-related operations.
final class FriendButtonState extends Equatable {
  const FriendButtonState._({
    this.status = FriendButtonStatus.initial,
    this.friendStatus = FriendStatus.empty,
    this.failure = FriendFailure.empty,
  });

  /// Creates an initial [FriendButtonState].
  const FriendButtonState.initial() : this._();

  final FriendButtonStatus status;
  final FriendStatus friendStatus;
  final FriendFailure failure;

  // Rebuilds the widget when the props change
  @override
  List<Object?> get props => [
        status,
        friendStatus,
        failure,
      ];

  /// Creates a new [FriendButtonState] with updated fields.
  /// Any parameter that is not provided will retain its current value.
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

/// Extension methods for convenient state checks.
extension FriendButtonStateExtensions on FriendButtonState {
  bool get isLoaded => status == FriendButtonStatus.loaded;
  bool get isLoading => status == FriendButtonStatus.loading;
  bool get isFailure => status == FriendButtonStatus.failure;
  bool get isEmpty => status == FriendButtonStatus.empty;
}

/// Extension methods for creating new [FriendButtonState] instances.
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
