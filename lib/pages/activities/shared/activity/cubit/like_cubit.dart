import 'package:app_core/app_core.dart';
import 'package:items_repository/items_repository.dart';

part 'like_state.dart';

class LikeCubit extends Cubit<LikeState> {
  LikeCubit(this._itemsRepository) : super(LikeInitial());

  final ItemsRepository _itemsRepository;

  Future<void> toggleLike(
    String userID,
    String itemID, {
    required bool liked,
  }) async {
    try {
      emit(LikeLoading());
      final updatedLikes = await _itemsRepository.updateItemLikes(
        userID: userID,
        itemID: itemID,
        isLiked: liked,
      );
      emit(LikeSuccess(isLiked: !liked, likes: updatedLikes));
    } catch (e) {
      emit(LikeFailure(message: e.toString()));
    }
  }
}
