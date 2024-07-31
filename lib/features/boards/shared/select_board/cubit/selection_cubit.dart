import 'package:app_core/app_core.dart';
import 'package:board_repository/board_repository.dart';

part 'selection_state.dart';

class SelectionCubit extends Cubit<SelectionState> {
  SelectionCubit(this._boardRepository) : super(SelectionInitial());

  final BoardRepository _boardRepository;

  Future<void> toggleSelection(
    String boardID,
    String postID, {
    required bool isSelected,
  }) async {
    emit(SelectionLoading());
    try {
      await _boardRepository.updateBoardPosts(
        boardID: boardID,
        postID: postID,
        isSelected: isSelected,
      );
      emit(SelectionSuccess(isSelected: !isSelected));
    } catch (e) {
      emit(SelectionFailure(message: e.toString()));
    }
  }
}
