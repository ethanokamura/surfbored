import 'package:app_core/app_core.dart';
import 'package:comment_repository/comment_repository.dart';

part 'comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  CommentsCubit({
    required CommentRepository commentRepository,
  })  : _commentRepository = commentRepository,
        super(const CommentsState.initial());

  final CommentRepository _commentRepository;

  Future<void> createComment(
    String postID,
    String senderID,
    String comment,
  ) async {
    try {
      await _commentRepository.createComment(
        comment: Comment(
          postId: postID,
          senderId: senderID,
          message: comment,
        ),
      );
    } on CommentFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  void readComments(String postID, {bool isLoadMore = false}) {
    emit(state.fromLoading());
    try {
      _commentRepository.streamComments(postID: postID).listen(
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
    String commentId,
  ) async {
    try {
      await _commentRepository.deleteComment(commentId: commentId);
    } on CommentFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }
}
