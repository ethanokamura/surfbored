import 'package:app_core/app_core.dart';
import 'package:board_repository/board_repository.dart';

part 'selection_state.dart';

class SelectionCubit extends Cubit<SelectionState> {
  SelectionCubit(this._boardRepository) : super(SelectionInitial());

  final BoardRepository _boardRepository;

  Future<void> isSelected(int boardId, int postId) async {
    try {
      final isSelected =
          await _boardRepository.hasPost(boardId: boardId, postId: postId);
      emit(SelectionSuccess(isSelected: isSelected));
    } catch (e) {
      emit(SelectionFailure(message: e.toString()));
    }
  }

  Future<void> toggleSelection({
    required int boardId,
    required int postId,
    required bool isSelected,
  }) async {
    emit(SelectionLoading());
    try {
      isSelected = !isSelected;
      if (isSelected) {
        await _boardRepository.addPost(
          boardPost: BoardPost(postId: postId, boardId: boardId),
        );
      } else {
        await _boardRepository.removePost(postId: postId, boardId: boardId);
      }
      emit(SelectionSuccess(isSelected: isSelected));
    } catch (e) {
      emit(SelectionFailure(message: e.toString()));
    }
  }
}
