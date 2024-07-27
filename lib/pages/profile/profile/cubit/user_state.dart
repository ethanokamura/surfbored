part of 'user_cubit.dart';

enum UserStatus { initial, loading, empty, loaded, failure }

final class UserState extends Equatable {
  const UserState._({
    this.status = UserStatus.initial,
    this.items = const [],
    this.failure = UserFailure.empty,
  });

  const UserState.initial() : this._();

  final UserStatus status;
  final List<String> items;
  final UserFailure failure;

  @override
  List<Object?> get props => [
        status,
        items,
        failure,
      ];

  UserState copyWith({
    UserStatus? status,
    List<String>? items,
    UserFailure? failure,
  }) {
    return UserState._(
      status: status ?? this.status,
      items: items ?? this.items,
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
