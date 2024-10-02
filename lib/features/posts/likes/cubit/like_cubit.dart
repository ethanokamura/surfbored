import 'package:app_core/app_core.dart';
import 'package:post_repository/post_repository.dart';

part 'like_state.dart';

class LikeCubit extends Cubit<LikeState> {
  LikeCubit(this._postRepository) : super(const LikeState.initial());

  final PostRepository _postRepository;

  Future<void> fetchData(int postId, String userId) async {
    final userLikesPost =
        await _postRepository.hasUserLikedPost(postId: postId, userId: userId);
    final likes = await _postRepository.fetchPostLikes(postId: postId);
    emit(state.fromLikeSuccess(isLiked: userLikesPost, likes: likes));
  }

  Future<void> toggleLike(
    String userId,
    int postId, {
    required bool liked,
  }) async {
    try {
      emit(state.fromLoading());
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
      emit(state.fromLikeSuccess(isLiked: !liked, likes: likes));
    } catch (e) {
      throw Exception(e);
    }
  }
}
