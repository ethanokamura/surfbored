part of 'post_cubit.dart';

/// Represents the different states a post can be in.
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

/// Represents the state of post-related operations.
final class PostState extends Equatable {
  /// Private constructor for creating [PostState] instances.
  const PostState._({
    this.status = PostStatus.initial,
    this.post = Post.empty,
    this.posts = const [],
    this.tags = const [],
    this.photoUrl = '',
    this.failure = PostFailure.empty,
  });

  /// Creates an initial [PostState].
  const PostState.initial() : this._();

  final PostStatus status;
  final Post post;
  final String photoUrl;
  final List<Post> posts;
  final List<String> tags;
  final PostFailure failure;

  // Rebuilds the widget when the props change
  @override
  List<Object?> get props => [
        status,
        post,
        photoUrl,
        tags,
        posts,
        failure,
      ];

  /// Creates a new [PostState] with updated fields.
  /// Any parameter that is not provided will retain its current value.
  PostState copyWith({
    PostStatus? status,
    Post? post,
    String? photoUrl,
    List<Post>? posts,
    List<String>? tags,
    PostFailure? failure,
  }) {
    return PostState._(
      status: status ?? this.status,
      post: post ?? this.post,
      photoUrl: photoUrl ?? this.photoUrl,
      tags: tags ?? this.tags,
      posts: posts ?? this.posts,
      failure: failure ?? this.failure,
    );
  }
}

/// Extension methods for convenient state checks.
extension PostStateExtensions on PostState {
  bool get isEmpty => status == PostStatus.empty;
  bool get isLoaded => status == PostStatus.loaded;
  bool get isLoading => status == PostStatus.loading;
  bool get isLoadingMore => status == PostStatus.loadingMore;
  bool get isFailure => status == PostStatus.failure;
  bool get isDeleted => status == PostStatus.deleted;
  bool get isUpdated => status == PostStatus.updated;
}

/// Extension methods for creating new [PostState] instances.
extension _PostStateExtensions on PostState {
  PostState fromLoading() => copyWith(status: PostStatus.loading);

  PostState fromSetImage(String url) =>
      copyWith(status: PostStatus.loaded, photoUrl: url);

  PostState fromEmpty() => copyWith(posts: [], status: PostStatus.empty);

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
