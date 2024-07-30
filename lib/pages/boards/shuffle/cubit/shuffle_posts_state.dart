part of 'shuffle_posts_cubit.dart';

enum ShufflePostsStatus {
  initial,
  loading,
  empty,
  loaded,
  deleted,
  created,
  creating,
  failure,
}

final class ShufflePostsState extends Equatable {
  const ShufflePostsState._({
    this.status = ShufflePostsStatus.initial,
    this.posts = const [],
    this.failure = BoardFailure.empty,
    this.index = 0,
  });

  const ShufflePostsState.initial() : this._();

  final ShufflePostsStatus status;
  final List<String> posts;
  final BoardFailure failure;
  final int index;

  @override
  List<Object?> get props => [
        status,
        posts,
        failure,
        index,
      ];

  ShufflePostsState copyWith({
    ShufflePostsStatus? status,
    List<String>? posts,
    BoardFailure? failure,
    int? index,
  }) {
    return ShufflePostsState._(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      failure: failure ?? this.failure,
      index: index ?? this.index,
    );
  }
}

extension ShufflePostsStateExtensions on ShufflePostsState {
  bool get isEmpty => status == ShufflePostsStatus.empty;
  bool get isLoaded => status == ShufflePostsStatus.loaded;
  bool get isLoading => status == ShufflePostsStatus.loading;
  bool get isFailure => status == ShufflePostsStatus.failure;
  bool get canIncrement => index < posts.length - 1;
  bool get canDecrement => index > 0;
}
