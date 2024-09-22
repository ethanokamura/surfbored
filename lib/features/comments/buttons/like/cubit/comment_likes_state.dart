part of 'comment_likes_cubit.dart';

enum CommentLikesStatus {
  initial,
  loading,
  loaded,
  liked,
  success,
  failure,
}

final class CommentLikesState extends Equatable {
  const CommentLikesState._({
    this.status = CommentLikesStatus.initial,
    this.liked = false,
    this.likes = 0,
  });

  // initial state
  const CommentLikesState.initial() : this._();

  final CommentLikesStatus status;
  final bool liked;
  final int likes;

  // rebuilds the app when the props change
  @override
  List<Object?> get props => [
        status,
        liked,
        likes,
      ];

  CommentLikesState copyWith({
    CommentLikesStatus? status,
    bool? liked,
    int? likes,
  }) {
    return CommentLikesState._(
      status: status ?? this.status,
      liked: liked ?? this.liked,
      likes: likes ?? this.likes,
    );
  }
}

extension CommentLikesStateExtensions on CommentLikesState {
  bool get isLoaded => status == CommentLikesStatus.loaded;
  bool get isLoading => status == CommentLikesStatus.loading;
  bool get isFailure => status == CommentLikesStatus.failure;
  bool get isCommentLiked => status == CommentLikesStatus.liked;
  bool get isSuccess => status == CommentLikesStatus.success;
}

extension _CommentLikesStateExtensions on CommentLikesState {
  CommentLikesState fromLoading() =>
      copyWith(status: CommentLikesStatus.loading);

  CommentLikesState fromLoaded({
    required bool liked,
    required int likes,
  }) =>
      copyWith(
        status: CommentLikesStatus.success,
        liked: liked,
        likes: likes,
      );
}
