part of 'post_cubit.dart';

enum PostStatus {
  initial,
  loading,
  loadingMore,
  empty,
  loaded,
  deleted,
  updated,
  failure,
}

final class PostState extends Equatable {
  const PostState._({
    this.status = PostStatus.initial,
    this.post = Post.empty,
    this.posts = const [],
    this.failure = PostFailure.empty,
  });

  // initial state
  const PostState.initial() : this._();

  final PostStatus status;
  final Post post;
  final List<Post> posts;
  final PostFailure failure;

  // rebuilds the app when the props change
  @override
  List<Object?> get props => [
        status,
        post,
        posts,
        failure,
      ];

  PostState copyWith({
    PostStatus? status,
    Post? post,
    List<Post>? posts,
    PostFailure? failure,
  }) {
    return PostState._(
      status: status ?? this.status,
      post: post ?? this.post,
      posts: posts ?? this.posts,
      failure: failure ?? this.failure,
    );
  }
}

extension PostStateExtensions on PostState {
  bool get isEmpty => status == PostStatus.empty;
  bool get isLoaded => status == PostStatus.loaded;
  bool get isLoading => status == PostStatus.loading;
  bool get isLoadingMore => status == PostStatus.loadingMore;
  bool get isFailure => status == PostStatus.failure;
  bool get isDeleted => status == PostStatus.deleted;
  bool get isUpdated => status == PostStatus.updated;
}

extension _PostStateExtensions on PostState {
  PostState fromLoading() => copyWith(status: PostStatus.loading);

  PostState fromEmpty() => copyWith(status: PostStatus.empty);

  PostState fromDeleted() => copyWith(status: PostStatus.deleted);

  PostState fromUpdate() => copyWith(status: PostStatus.updated);

  PostState fromPostLoaded(Post post) => copyWith(
        status: PostStatus.loaded,
        post: post,
      );

  PostState fromPostsLoaded(List<Post> posts) => copyWith(
        status: PostStatus.loaded,
        posts: posts,
      );

  PostState fromFailure(PostFailure failure) => copyWith(
        status: PostStatus.failure,
        failure: failure,
      );
}
