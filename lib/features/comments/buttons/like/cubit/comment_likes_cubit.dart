import 'package:app_core/app_core.dart';
import 'package:comment_repository/comment_repository.dart';

part 'comment_likes_state.dart';

class CommentLikesCubit extends Cubit<CommentLikesState> {
  CommentLikesCubit(this._commentRepository)
      : super(const CommentLikesState.initial());

  final CommentRepository _commentRepository;

  Future<void> fetchCommentData(
    String postID,
    String commentID,
    String userID,
  ) async {
    emit(state.fromLoading());
    final data = await _commentRepository.fetchComment(postID, commentID);
    final liked = data.likedByUser(userID);
    final likes = data.likes;
    emit(state.fromLoaded(liked: liked, likes: likes));
  }

  Future<void> toggleLike(
    String postID,
    String commentID,
    String userID, {
    required bool liked,
  }) async {
    liked = !liked;
    try {
      emit(state.fromLoading());
      await _commentRepository.updateLikes(
        postID: postID,
        commentID: commentID,
        userID: userID,
        liked: liked,
      );
      final likes = await _commentRepository.fetchLikes(postID, commentID);
      emit(state.fromLoaded(liked: liked, likes: likes));
    } catch (e) {
      throw Exception(e);
    }
  }
}
