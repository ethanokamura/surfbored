part of 'user_cubit.dart';

enum UserStatus { initial, loading, empty, loaded, failure }

final class UserState extends Equatable {
  const UserState._({
    this.status = UserStatus.initial,
    this.posts = const [],
    this.failure = UserFailure.empty,
  });

  const UserState.initial() : this._();

  final UserStatus status;
  final List<String> posts;
  final UserFailure failure;

  @override
  List<Object?> get props => [
        status,
        posts,
        failure,
      ];

  UserState copyWith({
    UserStatus? status,
    List<String>? posts,
    UserFailure? failure,
  }) {
    return UserState._(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      failure: failure ?? this.failure,
    );
  }
}

extension UserStateExtensions on UserState {
  bool get isEmpty => status == UserStatus.empty;
  bool get isLoaded => status == UserStatus.loaded;
  bool get isLoading => status == UserStatus.loading;
  bool get isFailure => status == UserStatus.failure;
}
