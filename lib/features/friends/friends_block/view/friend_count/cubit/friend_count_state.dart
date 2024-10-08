part of 'friend_count_cubit.dart';

enum FriendCountStatus {
  initial,
  loading,
  loaded,
  failure,
  empty,
}

final class FriendCountState extends Equatable {
  const FriendCountState._({
    this.status = FriendCountStatus.initial,
    this.failure = FriendFailure.empty,
    this.friends = 0,
  });

  // initial state
  const FriendCountState.initial() : this._();

  final FriendCountStatus status;
  final FriendFailure failure;
  final int friends;

  // rebuilds the app when the props change
  @override
  List<Object?> get props => [
        status,
        failure,
        friends,
      ];

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

extension FriendControllerStateExtensions on FriendCountState {
  bool get isLoaded => status == FriendCountStatus.loaded;
  bool get isLoading => status == FriendCountStatus.loading;
  bool get isFailure => status == FriendCountStatus.failure;
  bool get isEmpty => status == FriendCountStatus.empty;
}

extension _FriendControllerStateExtensions on FriendCountState {
  FriendCountState fromLoading() => copyWith(status: FriendCountStatus.loading);
  FriendCountState fromFailure(FriendFailure failure) =>
      copyWith(failure: failure, status: FriendCountStatus.failure);
  FriendCountState fromLoaded({required int friends}) =>
      copyWith(friends: friends, status: FriendCountStatus.loaded);
}
