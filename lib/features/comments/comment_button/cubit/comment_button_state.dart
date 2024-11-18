part of 'comment_button_cubit.dart';

/// Represents the different states a comment operation can be in.
enum CommentButtonStatus {
  initial,
  loading,
  loaded,
  failure,
}

/// Represents the state of comment button related operations.
final class CommentButtonState extends Equatable {
  const CommentButtonState._({
    this.status = CommentButtonStatus.initial,
    this.comments = 0,
    this.failure = CommentFailure.empty,
  });

  /// Creates an initial [CommentButtonState].
  const CommentButtonState.initial() : this._();

  final CommentButtonStatus status;
  final CommentFailure failure;
  final int comments;

  // Rebuilds the widget when the props change
  @override
  List<Object?> get props => [
        status,
        failure,
        comments,
      ];

  /// Creates a new [CommentButtonState] with updated fields.
  /// Any parameter that is not provided will retain its current value.
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

/// Extension methods for convenient state checks.
extension CommentButtonStateExtensions on CommentButtonState {
  bool get isLoaded => status == CommentButtonStatus.loaded;
  bool get isLoading => status == CommentButtonStatus.loading;
  bool get isFailure => status == CommentButtonStatus.failure;
}

/// Extension methods for creating new [CommentButtonState] instances.
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
