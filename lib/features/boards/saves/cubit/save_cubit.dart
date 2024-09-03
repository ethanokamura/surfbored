import 'package:app_core/app_core.dart';
import 'package:board_repository/board_repository.dart';

part 'save_state.dart';

class SaveCubit extends Cubit<SaveState> {
  SaveCubit(this._boardRepository) : super(const SaveState.initial());

  final BoardRepository _boardRepository;

  Future<void> fetchData(String boardID, String userID) async {
    final userSavedBoard =
        await _boardRepository.hasUserSavedBoard(boardID, userID);
    final saves = await _boardRepository.fetchSaves(boardID);
    emit(state.fromSaveSuccess(isSaved: userSavedBoard, saves: saves));
  }

  Future<void> toggleSave(
    String userID,
    String ownerID,
    String boardID, {
    required bool saved,
  }) async {
    try {
      emit(state.fromLoading());
      await _boardRepository.updateSaves(
        userID: userID,
        ownerID: ownerID,
        boardID: boardID,
        isSaved: saved,
      );
      final saves = await _boardRepository.fetchSaves(boardID);
      emit(state.fromSaveSuccess(isSaved: !saved, saves: saves));
    } catch (e) {
      throw Exception(e);
    }
  }
}
