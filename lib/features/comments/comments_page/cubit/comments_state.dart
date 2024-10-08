part of 'comments_cubit.dart';

enum CommentsStatus {
  initial,
  loading,
  empty,
  loaded,
  failure,
}

final class CommentsState extends Equatable {
  const CommentsState._({
    this.status = CommentsStatus.initial,
    this.comment = Comment.empty,
    this.comments = const [],
    this.failure = CommentFailure.empty,
  });

  // initial state
  const CommentsState.initial() : this._();

  final CommentsStatus status;
  final Comment comment;
  final List<Comment> comments;
  final CommentFailure failure;

  // rebuilds the app when the props change
  @override
  List<Object?> get props => [
        status,
        comment,
        comments,
        failure,
      ];

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

extension CommentStateExtensions on CommentsState {
  bool get isEmpty => status == CommentsStatus.empty;
  bool get isLoaded => status == CommentsStatus.loaded;
  bool get isLoading => status == CommentsStatus.loading;
  bool get isFailure => status == CommentsStatus.failure;
}

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
