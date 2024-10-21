part of 'friends_cubit.dart';

/// Represents the different states a friends can be in.
enum FriendsStatus {
  initial,
  loading,
  loaded,
  failure,
  empty,
}

/// Represents the state of friend-related operations.
final class FriendsState extends Equatable {
  /// Private constructor for creating [FriendsState] instances.
  const FriendsState._({
    this.status = FriendsStatus.initial,
    this.friends = const [],
    this.failure = FriendFailure.empty,
  });

  /// Creates an initial [FriendsState].
  const FriendsState.initial() : this._();

  final FriendsStatus status;
  final FriendFailure failure;
  final List<String> friends;

  // Rebuilds the widget when the props change
  @override
  List<Object?> get props => [
        status,
        failure,
        friends,
      ];

  /// Creates a new [FriendsState] with updated fields.
  /// Any parameter that is not provided will retain its current value.
  FriendsState copyWith({
    FriendsStatus? status,
    FriendFailure? failure,
    List<String>? friends,
  }) {
    return FriendsState._(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      friends: friends ?? this.friends,
    );
  }
}

/// Extension methods for convenient state checks.
extension FriendsStateExtensions on FriendsState {
  bool get isLoaded => status == FriendsStatus.loaded;
  bool get isLoading => status == FriendsStatus.loading;
  bool get isFailure => status == FriendsStatus.failure;
  bool get isEmpty => status == FriendsStatus.empty;
}

/// Extension methods for creating new [FriendsState] instances.
extension _FriendsStateExtensions on FriendsState {
  FriendsState fromLoading() => copyWith(status: FriendsStatus.loading);

  FriendsState fromEmpty() =>
      copyWith(friends: [], status: FriendsStatus.empty);

  FriendsState fromLoaded(List<String> friends) =>
      copyWith(status: FriendsStatus.loaded, friends: friends);

  FriendsState fromFailure(FriendFailure failure) => copyWith(
        status: FriendsStatus.failure,
        failure: failure,
      );
}
