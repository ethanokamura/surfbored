import 'package:app_core/app_core.dart';
import 'package:board_repository/board_repository.dart';

part 'save_state.dart';

class SaveCubit extends Cubit<SaveState> {
  SaveCubit(this._boardRepository) : super(const SaveState.initial());

  final BoardRepository _boardRepository;

  Future<void> fetchData(int boardId, String userId) async {
    final userSavedBoard = await _boardRepository.hasUserSavedBoard(
      boardId: boardId,
      userId: userId,
    );
    final saves = await _boardRepository.fetchBoardSaves(boardId: boardId);
    emit(state.fromSaveSuccess(isSaved: userSavedBoard, saves: saves));
  }

  Future<void> toggleSave({
    required String userId,
    required int boardId,
    required bool saved,
  }) async {
    try {
      emit(state.fromLoading());
      if (saved) {
        await _boardRepository.saveBoard(
          save: BoardSave(userId: userId, boardId: boardId),
        );
      } else {
        await _boardRepository.removeSave(boardId: boardId, userId: userId);
      }
      final saves = await _boardRepository.fetchBoardSaves(boardId: boardId);
      emit(state.fromSaveSuccess(isSaved: !saved, saves: saves));
    } catch (e) {
      throw Exception(e);
    }
  }
}
