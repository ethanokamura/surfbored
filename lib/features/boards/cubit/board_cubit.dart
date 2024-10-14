import 'package:app_core/app_core.dart';
import 'package:board_repository/board_repository.dart';
part 'board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  BoardCubit({
    required BoardRepository boardRepository,
  })  : _boardRepository = boardRepository,
        super(const BoardState.initial());

  final BoardRepository _boardRepository;

  int index = 0;
  int _currentPage = 0;
  final int _pageSize = 10;
  bool _hasMore = true;

  bool get hasMore => _hasMore;

  Future<void> fetchBoard(int boardId) async {
    emit(state.fromLoading());
    try {
      final board = await _boardRepository.fetchBoard(boardId: boardId);
      emit(state.fromBoardLoaded(board));
    } on BoardFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  Future<void> isSelected(int boardId, int postId) async {
    emit(state.fromLoading());
    try {
      final selected =
          await _boardRepository.hasPost(boardId: boardId, postId: postId);
      emit(state.fromSelectionLoaded(selected: selected));
    } on BoardFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

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
        _hasMore = false; // No more boards to load
        emit(state.fromEmpty());
      } else {
        if (boards.length <= _pageSize) {
          _hasMore = false;
        } else {
          _currentPage++; // Increment the page number
        }
        emit(state.fromBoardsLoaded([...state.boards, ...boards]));
      }
    } on BoardFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  Stream<List<Board>> streamUserBoards(String userId) =>
      _boardRepository.streamUserBoards(userId: userId);

  Future<void> editField(int boardId, String field, dynamic data) async {
    emit(state.fromLoading());
    await _boardRepository.updateBoard(
      boardId: boardId,
      field: field,
      data: data,
    );
    emit(state.fromUpdated());
    await fetchBoard(boardId);
  }

  Future<void> deleteBoard(
    int boardId,
  ) async {
    emit(state.fromLoading());
    try {
      await _boardRepository.deleteBoard(boardId: boardId);
      emit(state.fromDeleted());
    } on BoardFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }
}

extension _BoardStateExtensions on BoardState {
  BoardState fromLoading() => copyWith(status: BoardStatus.loading);

  BoardState fromEmpty() => copyWith(posts: [], status: BoardStatus.empty);

  BoardState fromDeleted() => copyWith(status: BoardStatus.deleted);

  BoardState fromUpdated() => copyWith(status: BoardStatus.updated);

  BoardState fromBoardLoaded(Board board) => copyWith(
        status: BoardStatus.loaded,
        board: board,
      );

  BoardState fromSelectionLoaded({required bool selected}) => copyWith(
        status: BoardStatus.loaded,
        selected: selected,
      );

  BoardState fromBoardsLoaded(List<Board> boards) => copyWith(
        status: BoardStatus.loaded,
        boards: boards,
      );

  BoardState fromFailure(BoardFailure failure) => copyWith(
        status: BoardStatus.failure,
        failure: failure,
      );
}
