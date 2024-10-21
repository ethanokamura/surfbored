part of 'comments_cubit.dart';

/// Represents the different states a comment operation can be in.
enum CommentsStatus {
  initial,
  loading,
  empty,
  loaded,
  failure,
}

/// Represents the state of comment-related operations.
final class CommentsState extends Equatable {
  /// Private constructor for creating [CommentsState] instances.
  const CommentsState._({
    this.status = CommentsStatus.initial,
    this.comment = Comment.empty,
    this.comments = const [],
    this.failure = CommentFailure.empty,
  });

  /// Creates an initial [CommentsState].
  const CommentsState.initial() : this._();

  final CommentsStatus status;
  final Comment comment;
  final List<Comment> comments;
  final CommentFailure failure;

  // Rebuilds the widget when the props change
  @override
  List<Object?> get props => [
        status,
        comment,
        comments,
        failure,
      ];

  /// Creates a new [CommentsState] with updated fields.
  /// Any parameter that is not provided will retain its current value.
  CommentsState copyWith({
    CommentsStatus? status,
    Comment? comment,
    List<Comment>? comments,
    CommentFailure? failure,
  }) {
    return CommentsState._(
      status: status ?? this.status,
      comment: comment ?? this.comment,
      comments: comments ?? this.comments,
      failure: failure ?? this.failure,
    );
  }
}

/// Extension methods for convenient state checks.
extension CommentStateExtensions on CommentsState {
  bool get isEmpty => status == CommentsStatus.empty;
  bool get isLoaded => status == CommentsStatus.loaded;
  bool get isLoading => status == CommentsStatus.loading;
  bool get isFailure => status == CommentsStatus.failure;
}

/// Extension methods for creating new [CommentsState] instances.
extension _CommentStateExtensions on CommentsState {
  CommentsState fromLoading() => copyWith(status: CommentsStatus.loading);

  CommentsState fromEmpty() =>
      copyWith(comments: [], status: CommentsStatus.empty);

  CommentsState fromCommentsLoaded(
    List<Comment> comments,
  ) =>
      copyWith(
        status: CommentsStatus.loaded,
        comments: comments,
      );

  CommentsState fromFailure(CommentFailure failure) => copyWith(
        status: CommentsStatus.failure,
        failure: failure,
      );
}
