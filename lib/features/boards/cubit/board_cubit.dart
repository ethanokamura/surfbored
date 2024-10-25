import 'package:app_core/app_core.dart';
import 'package:board_repository/board_repository.dart';
part 'board_state.dart';

/// Manages the state and logic for board-related operations.
class BoardCubit extends Cubit<BoardState> {
  /// Creates a new instance of [BoardCubit].
  /// Requires a [BoardRepository] to handle data operations.
  BoardCubit({
    required BoardRepository boardRepository,
  })  : _boardRepository = boardRepository,
        super(const BoardState.initial());

  final BoardRepository _boardRepository;

  int _currentPage = 0;
  final int _pageSize = 10;
  bool _hasMore = true;

  /// Indicates if there are more boards to fetch.
  bool get hasMore => _hasMore;

  /// Fetches a specific board by its ID.
  Future<void> fetchBoard(int boardId) async {
    emit(state.fromLoading());
    try {
      final board = await _boardRepository.fetchBoard(boardId: boardId);
      emit(state.fromBoardLoaded(board));
    } on BoardFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  /// Fetches boards for a specific user.
  /// If [refresh] is true, resets pagination and fetches from the beginning.
  /// Implements pagination, fetching [_pageSize] boards at a time.
  Future<void> fetchBoards(String userId, {bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMore = true;
      emit(state.fromEmpty());
    }

    if (!_hasMore) return;

    emit(state.fromLoading());
    try {
      final boards = await _boardRepository.fetchUserBoards(
        userId: userId,
        offset: _currentPage * _pageSize,
        limit: _pageSize,
      );

      if (boards.isEmpty) {
        _hasMore = false;
        emit(state.fromEmpty());
      } else {
        if (boards.length <= _pageSize) {
          _hasMore = false;
        } else {
          _currentPage++;
        }
        emit(state.fromBoardsLoaded([...state.boards, ...boards]));
      }
    } on BoardFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  /// Provides a stream of boards for a specific user.
  Stream<List<Board>> streamUserBoards(String userId) =>
      _boardRepository.streamUserBoards(userId: userId);

  /// Edits a specific field of a board.
  /// After updating, re-fetches the board to ensure state consistency.
  Future<void> editField(int boardId, String field, dynamic data) async {
    emit(state.fromLoading());
    await _boardRepository.updateBoardField(
      boardId: boardId,
      field: field,
      data: data,
    );
    emit(state.fromUpdated());
    await fetchBoard(boardId);
  }

  /// Updates the given of a board.
  Future<void> updateBoard(int boardId, Map<String, dynamic> data) async {
    emit(state.fromLoading());
    final board =
        await _boardRepository.updateBoard(boardId: boardId, data: data);
    emit(state.fromBoardLoaded(board));
  }

  /// Deletes a board by its ID.
  /// Emits a loading state, then either a deleted state or a failure state.
  Future<void> deleteBoard(int boardId) async {
    emit(state.fromLoading());
    try {
      await _boardRepository.deleteBoard(boardId: boardId);
      emit(state.fromDeleted());
    } on BoardFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }
}
