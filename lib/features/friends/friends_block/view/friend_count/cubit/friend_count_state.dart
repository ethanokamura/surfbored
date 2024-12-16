part of 'friend_count_cubit.dart';

/// Represents the different states a friend count can be in.
enum FriendCountStatus {
  initial,
  loading,
  loaded,
  failure,
  empty,
}

/// Represents the state of friend count operations.
final class FriendCountState extends Equatable {
  /// Private constructor for creating [FriendCountState] instances.
  const FriendCountState._({
    this.status = FriendCountStatus.initial,
    this.failure = FriendFailure.empty,
    this.friends = 0,
  });

  /// Creates an initial [FriendCountState].
  const FriendCountState.initial() : this._();

  final FriendCountStatus status;
  final FriendFailure failure;
  final int friends;

  // Rebuilds the widget when the props change
  @override
  List<Object?> get props => [
        status,
        failure,
        friends,
      ];

  /// Creates a new [FriendCountState] with updated fields.
  /// Any parameter that is not provided will retain its current value.
  FriendCountState copyWith({
    FriendCountStatus? status,
    FriendFailure? failure,
    int? friends,
  }) {
    return FriendCountState._(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      friends: friends ?? this.friends,
    );
  }
}

/// Extension methods for convenient state checks.
extension FriendControllerStateExtensions on FriendCountState {
  bool get isLoaded => status == FriendCountStatus.loaded;
  bool get isLoading => status == FriendCountStatus.loading;
  bool get isFailure => status == FriendCountStatus.failure;
  bool get isEmpty => status == FriendCountStatus.empty;
}

/// Extension methods for creating new [FriendCountState] instances.
extension _FriendControllerStateExtensions on FriendCountState {
  FriendCountState fromLoading() => copyWith(status: FriendCountStatus.loading);
  FriendCountState fromFailure(FriendFailure failure) =>
      copyWith(failure: failure, status: FriendCountStatus.failure);
  FriendCountState fromLoaded({required int friends}) =>
      copyWith(friends: friends, status: FriendCountStatus.loaded);
}
