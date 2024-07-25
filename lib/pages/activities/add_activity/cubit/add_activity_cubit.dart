import 'package:bloc/bloc.dart';
import 'package:boards_repository/boards_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'add_activity_state.dart';

class AddActivityCubit extends Cubit<AddActivityState> {
  AddActivityCubit(
      {required this.boardsRepository, required this.userRepository})
      : super(BoardInitial());

  final BoardsRepository boardsRepository;
  final UserRepository userRepository;

  void streamBoard(String boardID) {
    emit(BoardLoading());
    boardsRepository.readBoardStream(boardID).listen(
      (board) {
        emit(BoardLoaded(board: board));
      },
      onError: (error) {
        emit(const BoardError(message: 'Failed to load board.'));
      },
    );
  }

  void streamUserBoards(String userID) {
    emit(BoardLoading());
    userRepository.getBoardsStream(userRepository.getCurrentUserID()).listen(
      (boards) {
        emit(BoardsLoaded(boards: boards));
      },
      onError: (error) {
        emit(const BoardError(message: 'Failed to load boards.'));
      },
    );
  }

  Future<void> toggleItemSelection(
      String boardID, String itemID, bool isSelected) async {
    try {
      await boardsRepository.updateBoardItems(
        boardID: boardID,
        itemID: itemID,
        isSelected: isSelected,
      );
      emit(BoardItemToggled(isSelected: isSelected));
    } catch (e) {
      emit(const BoardError(message: 'Failed to toggle item.'));
    }
  }

  Future<void> checkIfIncluded(String boardID, String itemID) async {
    try {
      final isIncluded =
          await boardsRepository.boardIncludesItem(boardID, itemID);
      emit(BoardItemChecked(isIncluded: isIncluded));
    } catch (e) {
      emit(const BoardError(message: 'Failed to check item.'));
    }
  }
}
