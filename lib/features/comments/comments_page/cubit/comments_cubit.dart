import 'package:app_core/app_core.dart';
import 'package:comment_repository/comment_repository.dart';

part 'comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  CommentsCubit({
    required CommentRepository commentRepository,
  })  : _commentRepository = commentRepository,
        super(const CommentsState.initial());

  final CommentRepository _commentRepository;

  Future<void> createComment({
    required int postId,
    required String postCreatorId,
    required String senderId,
    required String message,
  }) async {
    try {
      await _commentRepository.createComment(
        postId: postId,
        postCreatorId: postCreatorId,
        senderId: senderId,
        message: message,
      );
    } on CommentFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

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
