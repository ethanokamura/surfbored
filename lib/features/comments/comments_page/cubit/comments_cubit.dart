import 'package:app_core/app_core.dart';
import 'package:comment_repository/comment_repository.dart';

part 'comments_state.dart';

/// Manages the state and logic for comment-related operations.
class CommentsCubit extends Cubit<CommentsState> {
  /// Creates a new instance of [CommentsCubit].
  /// Requires a [CommentRepository] to handle data operations.
  CommentsCubit({
    required CommentRepository commentRepository,
  })  : _commentRepository = commentRepository,
        super(const CommentsState.initial());

  final CommentRepository _commentRepository;

  /// Creates a comment for a given post by ID
  /// Requires [postCreatorId] to keep the OP's ID in the comment data
  /// Requires [senderId] to keep track of who wrote the comment
  /// Requires [message] for the actual comment data
  Future<void> createComment({
    required int postId,
    required String postCreatorId,
    required String senderId,
    required String message,
  }) async {
    try {
      await _commentRepository.createComment(
        comment: Comment(
          postId: postId,
          postCreatorId: postCreatorId,
          senderId: senderId,
          message: message,
        ),
      );
    } on CommentFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  /// Streams all the comments for a specific post.
  /// TODO(Ethan): implement pagination for streams
  void readComments(int postId, {bool isLoadMore = false}) {
    emit(state.fromLoading());
    try {
      _commentRepository.streamComments(postId: postId).listen(
        (comments) {
          if (comments.isEmpty) {
            emit(state.fromEmpty());
            return;
          }
          emit(state.fromCommentsLoaded(comments));
        },
        onError: (_) {
          emit(state.fromEmpty());
        },
      );
    } on CommentFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  Future<void> deleteComment(
    int commentId,
  ) async {
    try {
      await _commentRepository.deleteComment(commentId: commentId);
    } on CommentFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }
}
