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
    String userID,
    String senderID,
    String comment,
  ) async {
    try {
      await _commentRepository.createComment(
        Comment(
          docID: postID,
          ownerID: userID,
          senderID: senderID,
          message: comment,
        ),
        postID,
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

  Future<void> updateComment(
    String postID,
    String commentID,
    String comment,
  ) async {
    try {
      await _commentRepository.updateComment(postID, commentID, comment);
    } on CommentFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  Future<void> deleteComment(
    String postID,
    String commentID,
  ) async {
    try {
      await _commentRepository.deleteComment(postID, commentID);
    } on CommentFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }
}
