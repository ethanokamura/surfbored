import 'package:app_core/app_core.dart';
import 'package:comment_repository/comment_repository.dart';

part 'comment_likes_state.dart';

class CommentLikesCubit extends Cubit<CommentLikesState> {
  CommentLikesCubit(this._commentRepository)
      : super(const CommentLikesState.initial());

  final CommentRepository _commentRepository;

  Future<void> fetchCommentData(
    int userId,
    int commentId,
  ) async {
    emit(state.fromLoading());
    final liked = await _commentRepository.hasUserLikedComment(userId: userId);
    final likes =
        await _commentRepository.fetchCommentLikes(commentId: commentId);
    emit(state.fromLoaded(liked: liked, likes: likes));
  }

  Future<void> toggleLike({
    required int commentId,
    required int userId,
    required bool liked,
  }) async {
    liked = !liked;
    try {
      emit(state.fromLoading());
      if (liked) {
        await _commentRepository.likeComment(
          like: CommentLike(userId: userId, commentId: commentId),
        );
      } else {
        await _commentRepository.removeLike(
          commentId: commentId,
        );
      }
      final likes =
          await _commentRepository.fetchCommentLikes(commentId: commentId);
      emit(state.fromLoaded(liked: liked, likes: likes));
    } catch (e) {
      throw Exception(e);
    }
  }
}
