import 'package:app_core/app_core.dart';
import 'package:post_repository/post_repository.dart';

part 'like_state.dart';

/// Manages the state and logic for post like operations.
class LikeCubit extends Cubit<LikeState> {
  /// Creates a new instance of [LikeCubit].
  /// Requires a [PostRepository] to handle data operations.
  LikeCubit(this._postRepository) : super(const LikeState.initial());

  final PostRepository _postRepository;

  /// Fetches the number of likes and if the current like status via [postId].
  Future<void> fetchData(int postId, String userId) async {
    final userLikesPost =
        await _postRepository.hasUserLikedPost(postId: postId, userId: userId);
    final likes = await _postRepository.fetchPostLikes(postId: postId);
    emit(state.fromLikeSuccess(isLiked: userLikesPost, likes: likes));
  }

  /// Toggles the post to be liked or unliked
  /// Requires [postId] to toggle the specifc post
  /// Requires the [userId] of the current user
  Future<void> toggleLike(
    String userId,
    int postId, {
    required bool liked,
  }) async {
    try {
      emit(state.fromLoading());
      liked = !liked;
      if (liked) {
        await _postRepository.likePost(
          like: PostLike(
            userId: userId,
            postId: postId,
          ),
        );
      } else {
        await _postRepository.removeLike(
          postId: postId,
          userId: userId,
        );
      }
      final likes = await _postRepository.fetchPostLikes(postId: postId);
      emit(state.fromLikeSuccess(isLiked: liked, likes: likes));
    } catch (e) {
      throw Exception(e);
    }
  }
}
