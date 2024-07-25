import 'package:bloc/bloc.dart';
import 'package:boards_repository/boards_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

// State definitions
part 'board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  BoardCubit({
    required this.boardsRepository,
    required this.userRepository,
  }) : super(BoardInitial());

  final BoardsRepository boardsRepository;
  final UserRepository userRepository;
  int index = 0; // Add index tracking

  bool isOwner(String boardUserID, String currentUserID) {
    return boardUserID == currentUserID;
  }

  User getUser() {
    return userRepository.getCurrentUser();
  }

  Future<Board> fetchBoard(String boardID) async {
    try {
      final board = await boardsRepository.readBoard(boardID);
      return board;
    } catch (e) {
      BoardError(message: 'error fetching board: $e');
      return Board.empty;
    }
  }

  Future<List<String>> fetchBoardItems(String boardID) async {
    emit(BoardLoading());
    try {
      final items = await boardsRepository.readItems(boardID);
      emit(BoardItemsLoaded(items: items));
      return items;
    } catch (e) {
      emit(BoardError(message: 'Failed to fetch board.'));
      return [];
    }
  }

  Stream<BoardState> streamBoard(String boardID) async* {
    emit(BoardLoading());
    boardsRepository.readBoardStream(boardID).listen(
      (snapshot) {
        emit(BoardLoaded(board: snapshot));
      },
      onError: (dynamic error) {
        emit(BoardError(message: 'failed to load items: $error'));
      },
    );
  }

  Stream<BoardState> streamBoardItems(String boardID) async* {
    emit(BoardLoading());
    boardsRepository.readBoardItemStream(boardID).listen(
      (snapshot) {
        emit(BoardItemsLoaded(items: snapshot));
      },
      onError: (dynamic error) {
        emit(BoardError(message: 'failed to load items: $error'));
      },
    );
  }

  Stream<BoardState> streamUserBoards(String userID) async* {
    emit(UserBoardsLoading());
    userRepository.readUserBoardStream(userID).listen(
      (snapshot) {
        emit(UserBoardsLoaded(boards: snapshot));
      },
      onError: (dynamic error) {
        emit(BoardError(message: 'failed to load items: $error'));
      },
    );
  }

  Future<void> shuffleItemList(String boardID) async {
    emit(BoardLoading());
    try {
      final itemList = await fetchBoardItems(boardID);
      itemList.shuffle();
      emit(BoardItemsLoaded(items: itemList));
    } catch (e) {
      emit(BoardError(message: 'Failed to shuffle board.'));
    }
  }

  void skipItem() {
    if (state is BoardItemsLoaded) {
      final items = (state as BoardItemsLoaded).items;
      if (index + 1 < items.length) {
        index++;
        emit(BoardItemsLoaded(items: items)); // Emit updated state
      }
    }
  }

  Future<void> editField(String boardID, String field, String data) async {
    await boardsRepository.updateField(boardID, field, data);
  }

  Future<void> toggleLike(String userID, String boardID, bool isLiked) async {
    try {
      await boardsRepository.updateBoardLikes(
        userID: userID,
        boardID: boardID,
        isLiked: isLiked,
      );
      await fetchBoard(boardID);
      emit(BoardLiked(liked: isLiked));
    } catch (e) {
      emit(BoardError(message: 'Failed to shuffle board.'));
    }
  }

  Future<void> deleteBoard(
    String userID,
    String boardID,
    String photoURL,
  ) async {
    try {
      await boardsRepository.deleteBoard(userID, boardID, photoURL);
      emit(BoardDeleted());
    } catch (e) {
      emit(BoardError(message: 'failed to delete board'));
    }
  }
}
