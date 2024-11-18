part of 'comment_likes_cubit.dart';

/// Represents the different states a comment like operation can be in.
enum CommentLikesStatus {
  initial,
  loading,
  loaded,
  liked,
  success,
  failure,
}

/// Represents the state of comment like-related operations.
final class CommentLikesState extends Equatable {
  const CommentLikesState._({
    this.status = CommentLikesStatus.initial,
    this.liked = false,
    this.likes = 0,
  });

  /// Creates an initial [CommentLikesState].
  const CommentLikesState.initial() : this._();

  final CommentLikesStatus status;
  final bool liked;
  final int likes;

  // Rebuilds the widget when the props change
  @override
  List<Object?> get props => [
        status,
        liked,
        likes,
      ];

  /// Creates a new [CommentLikesState] with updated fields.
  /// Any parameter that is not provided will retain its current value.
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

/// Extension methods for convenient state checks.
extension CommentLikesStateExtensions on CommentLikesState {
  bool get isLoaded => status == CommentLikesStatus.loaded;
  bool get isLoading => status == CommentLikesStatus.loading;
  bool get isFailure => status == CommentLikesStatus.failure;
  bool get isCommentLiked => status == CommentLikesStatus.liked;
  bool get isSuccess => status == CommentLikesStatus.success;
}

/// Extension methods for creating new [CommentLikesState] instances.
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
