import 'package:bloc/bloc.dart';
import 'package:board_repository/board_repository.dart';
import 'package:equatable/equatable.dart';

// State definitions
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

  Future<void> fetchBoard(String boardID) async {
    emit(state.fromLoading());
    try {
      final board = await _boardRepository.fetchBoard(boardID);
      emit(state.fromBoardLoaded(board));
    } on BoardFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  void streamBoard(String boardID) {
    emit(state.fromLoading());
    try {
      _boardRepository.streamBoard(boardID).listen(
        (snapshot) {
          emit(state.fromBoardLoaded(snapshot));
        },
        onError: (dynamic error) {
          emit(state.fromFailure(BoardFailure.fromGetBoard()));
        },
      );
    } on BoardFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  bool hasMore() {
    return _hasMore;
  }

  void streamUserBoards(String userID) {
    emit(state.fromLoading());
    _currentPage = 0;
    _hasMore = true;
    _loadMoreUserBoards(userID, reset: true);
  }

  void loadMoreUserBoards(String userID) {
    if (_hasMore) {
      _currentPage++;
      _loadMoreUserBoards(userID);
    }
  }

  void _loadMoreUserBoards(String userID, {bool reset = false}) {
    try {
      _boardRepository
          .streamUserBoards(userID, pageSize: _pageSize, page: _currentPage)
          .listen(
        (boards) {
          if (boards.length < _pageSize) {
            _hasMore = false;
          }
          if (reset) {
            emit(state.fromBoardsLoaded(boards));
          } else {
            emit(state.fromBoardsLoaded(List.of(state.boards)..addAll(boards)));
          }
        },
        onError: (error) {
          emit(state.fromEmpty());
        },
      );
    } on BoardFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  Future<void> editField(String boardID, String field, dynamic data) async {
    emit(state.fromLoading());
    await _boardRepository.updateField(boardID, {field: data});
    emit(state.fromUpdated());
    await fetchBoard(boardID);
  }

  Future<void> deleteBoard(
    String userID,
    String boardID,
    String? photoURL,
  ) async {
    emit(state.fromLoading());
    try {
      final url = photoURL ?? '';
      await _boardRepository.deleteBoard(userID, boardID, url);
      emit(state.fromDeleted());
    } on BoardFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }
}

extension _BoardStateExtensions on BoardState {
  BoardState fromLoading() => copyWith(status: BoardStatus.loading);

  BoardState fromEmpty() => copyWith(status: BoardStatus.empty);

  BoardState fromDeleted() => copyWith(status: BoardStatus.deleted);

  BoardState fromUpdated() => copyWith(status: BoardStatus.updated);

  BoardState fromBoardLoaded(Board board) => copyWith(
        status: BoardStatus.loaded,
        board: board,
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
