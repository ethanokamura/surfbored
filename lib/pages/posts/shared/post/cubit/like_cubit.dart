import 'package:app_core/app_core.dart';
import 'package:post_repository/post_repository.dart';

part 'like_state.dart';

class LikeCubit extends Cubit<LikeState> {
  LikeCubit(this._postRepository) : super(LikeInitial());

  final PostRepository _postRepository;

  Future<void> toggleLike(
    String userID,
    String postID, {
    required bool liked,
  }) async {
    try {
      emit(LikeLoading());
      final updatedLikes = await _postRepository.updateLikes(
        userID: userID,
        postID: postID,
        isLiked: liked,
      );
      emit(LikeSuccess(isLiked: !liked, likes: updatedLikes));
    } catch (e) {
      emit(LikeFailure(message: e.toString()));
    }
  }
}
