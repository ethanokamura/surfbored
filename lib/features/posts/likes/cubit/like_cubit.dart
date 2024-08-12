import 'package:app_core/app_core.dart';
import 'package:post_repository/post_repository.dart';

part 'like_state.dart';

class LikeCubit extends Cubit<LikeState> {
  LikeCubit(this._postRepository) : super(const LikeState.initial());

  final PostRepository _postRepository;

  Future<void> fetchData(String postID, String userID) async {
    final userLikesPost =
        await _postRepository.hasUserLikedPost(postID, userID);
    final likes = await _postRepository.fetchLikes(postID);
    emit(state.fromLikeSuccess(isLiked: userLikesPost, likes: likes));
  }

  Future<void> toggleLike(
    String userID,
    String postID, {
    required bool liked,
  }) async {
    try {
      emit(state.fromLoading());
      await _postRepository.updateLikes(
        userID: userID,
        postID: postID,
        isLiked: liked,
      );
      final likes = await _postRepository.fetchLikes(postID);
      emit(state.fromLikeSuccess(isLiked: !liked, likes: likes));
    } catch (e) {
      throw Exception(e);
    }
  }
}
