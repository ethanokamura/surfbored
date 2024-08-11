part of 'activity_cubit.dart';

enum ActivityStatus {
  initial,
  loading,
  loadingMore,
  empty,
  loaded,
  created,
  creating,
  deleted,
  updated,
  failure,
}

final class ActivityState extends Equatable {
  const ActivityState._({
    this.status = ActivityStatus.initial,
    this.failure = UserFailure.empty,
    this.friendRequests = const [],
  });

  // initial state
  const ActivityState.initial() : this._();

  final ActivityStatus status;
  final UserFailure failure;
  final List<String> friendRequests;

  // rebuilds the app when the props change
  @override
  List<Object?> get props => [
        status,
        failure,
        friendRequests,
      ];

  ActivityState copyWith({
    ActivityStatus? status,
    UserFailure? failure,
    List<String>? friendRequests,
  }) {
    return ActivityState._(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      friendRequests: friendRequests ?? this.friendRequests,
    );
  }
}

extension ActivityStateExtensions on ActivityState {
  bool get isEmpty => status == ActivityStatus.empty;
  bool get isLoaded => status == ActivityStatus.loaded;
  bool get isLoading => status == ActivityStatus.loading;
  bool get isLoadingMore => status == ActivityStatus.loadingMore;
  bool get isFailure => status == ActivityStatus.failure;
  bool get isCreated => status == ActivityStatus.created;
  bool get isCreating => status == ActivityStatus.creating;
  bool get isDeleted => status == ActivityStatus.deleted;
  bool get isUpdated => status == ActivityStatus.updated;
}

extension _ActivityStateExtensions on ActivityState {
  ActivityState fromLoading() => copyWith(status: ActivityStatus.loading);

  ActivityState fromEmpty() => copyWith(status: ActivityStatus.empty);

  ActivityState fromFriendRequestsLoaded(List<String> senderIDs) => copyWith(
        status: ActivityStatus.loaded,
        friendRequests: senderIDs,
      );

  ActivityState fromFailure(UserFailure failure) => copyWith(
        status: ActivityStatus.failure,
        failure: failure,
      );
}
