import 'package:app_core/app_core.dart';
import 'package:board_repository/board_repository.dart';

part 'selection_state.dart';

class SelectionCubit extends Cubit<SelectionState> {
  SelectionCubit(this._boardRepository) : super(SelectionInitial());

  final BoardRepository _boardRepository;

  Future<void> toggleSelection({
    required int boardId,
    required int postId,
    required bool isSelected,
  }) async {
    emit(SelectionLoading());
    try {
      if (isSelected) {
        await _boardRepository.addPost(
          post: BoardPost(postId: postId, boardId: boardId),
        );
      } else {
        await _boardRepository.removePost(postId: postId, boardId: boardId);
      }
      emit(SelectionSuccess(isSelected: !isSelected));
    } catch (e) {
      emit(SelectionFailure(message: e.toString()));
    }
  }
}
