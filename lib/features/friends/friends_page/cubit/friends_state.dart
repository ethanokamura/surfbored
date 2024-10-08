part of 'friends_cubit.dart';

enum FriendsStatus {
  initial,
  loading,
  loaded,
  failure,
  empty,
}

final class FriendsState extends Equatable {
  const FriendsState._({
    this.status = FriendsStatus.initial,
    this.friends = const [],
    this.failure = FriendFailure.empty,
  });

  // initial state
  const FriendsState.initial() : this._();

  final FriendsStatus status;
  final FriendFailure failure;
  final List<String> friends;

  // rebuilds the app when the props change
  @override
  List<Object?> get props => [
        status,
        failure,
        friends,
      ];

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

extension FriendsStateExtensions on FriendsState {
  bool get isLoaded => status == FriendsStatus.loaded;
  bool get isLoading => status == FriendsStatus.loading;
  bool get isFailure => status == FriendsStatus.failure;
  bool get isEmpty => status == FriendsStatus.empty;
}

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
