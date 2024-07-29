part of 'activity_cubit.dart';

enum PostStatus {
  initial,
  loading,
  empty,
  loaded,
  created,
  creating,
  deleted,
  failure,
}

final class PostState extends Equatable {
  const PostState._({
    this.status = PostStatus.initial,
    this.post = Post.empty,
    this.posts = const [],
    this.failure = PostFailure.empty,
    this.liked = false,
  });

  const PostState.initial() : this._();

  final PostStatus status;
  final Post post;
  final List<Post> posts;
  final PostFailure failure;
  final bool liked;

  @override
  List<Object?> get props => [
        status,
        post,
        posts,
        failure,
        liked,
      ];

  PostState copyWith({
    PostStatus? status,
    Post? post,
    List<Post>? posts,
    PostFailure? failure,
    bool? liked,
  }) {
    return PostState._(
      status: status ?? this.status,
      post: post ?? this.post,
      posts: posts ?? this.posts,
      failure: failure ?? this.failure,
      liked: liked ?? this.liked,
    );
  }
}

extension BoardStateExtensions on PostState {
  bool get isEmpty => status == PostStatus.empty;
  bool get isLoaded => status == PostStatus.loaded;
  bool get isLoading => status == PostStatus.loading;
  bool get isFailure => status == PostStatus.failure;
  bool get isCreated => status == PostStatus.created;
  bool get isCreating => status == PostStatus.creating;
  bool get isDeleted => status == PostStatus.deleted;
}
