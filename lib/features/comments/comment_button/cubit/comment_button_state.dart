part of 'comment_button_cubit.dart';

enum CommentButtonStatus {
  initial,
  loading,
  loaded,
  failure,
}

final class CommentButtonState extends Equatable {
  const CommentButtonState._({
    this.status = CommentButtonStatus.initial,
    this.comments = 0,
    this.failure = CommentFailure.empty,
  });

  // initial state
  const CommentButtonState.initial() : this._();

  final CommentButtonStatus status;
  final CommentFailure failure;
  final int comments;

  // rebuilds the app when the props change
  @override
  List<Object?> get props => [
        status,
        failure,
        comments,
      ];

  CommentButtonState copyWith({
    CommentButtonStatus? status,
    CommentFailure? failure,
    int? comments,
  }) {
    return CommentButtonState._(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      comments: comments ?? this.comments,
    );
  }
}

extension CommentButtonStateExtensions on CommentButtonState {
  bool get isLoaded => status == CommentButtonStatus.loaded;
  bool get isLoading => status == CommentButtonStatus.loading;
  bool get isFailure => status == CommentButtonStatus.failure;
}

extension _CommentButtonStateExtensions on CommentButtonState {
  CommentButtonState fromLoading() =>
      copyWith(status: CommentButtonStatus.loading);

  CommentButtonState fromLoaded(int comments) =>
      copyWith(status: CommentButtonStatus.loaded, comments: comments);

  // CommentButtonState fromFailure(CommentFailure failure) => copyWith(
  //       status: CommentButtonStatus.failure,
  //       failure: failure,
  //     );
}
