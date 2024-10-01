import 'package:app_core/app_core.dart';
import 'package:board_repository/board_repository.dart';
import 'package:tag_repository/tag_repository.dart';

part 'board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  BoardCubit({
    required BoardRepository boardRepository,
    required TagRepository tagRepository,
  })  : _boardRepository = boardRepository,
        _tagRepository = tagRepository,
        super(const BoardState.initial());

  final BoardRepository _boardRepository;
  final TagRepository _tagRepository;

  int index = 0;

  int _currentPage = 0;
  final int _pageSize = 10;
  bool _hasMore = true;

  Future<void> fetchBoard(String boardId) async {
    emit(state.fromLoading());
    try {
      final board = await _boardRepository.fetchBoard(boardId: boardId);
      final tags = await _tagRepository.readBoardTags(uuid: boardId);
      emit(state.fromBoardLoaded(board, tags));
    } on BoardFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  Future<void> isSelected(String boardId, String postId) async {
    emit(state.fromLoading());
    try {
      final selected =
          await _boardRepository.hasPost(boardId: boardId, postId: postId);
      emit(state.fromSelectionLoaded(selected: selected));
    } on BoardFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  // void streamBoard(String boardId) {
  //   emit(state.fromLoading());
  //   try {
  //     _boardRepository.streamBoard(boardId).listen(
  //       (snapshot) {
  //         emit(state.fromBoardLoaded(snapshot));
  //       },
  //       onError: (dynamic error) {
  //         emit(state.fromFailure(BoardFailure.fromGetBoard()));
  //       },
  //     );
  //   } on BoardFailure catch (failure) {
  //     emit(state.fromFailure(failure));
  //   }
  // }

  // bool hasMore() {
  //   return _hasMore;
  // }

  // void streamUserBoards(String userID) {
  //   emit(state.fromLoading());
  //   _currentPage = 0;
  //   _hasMore = true;
  //   _loadMoreUserBoards(userID, reset: true);
  // }

  // void loadMoreUserBoards(String userID) {
  //   if (_hasMore) {
  //     _currentPage++;
  //     _loadMoreUserBoards(userID);
  //   }
  // }

  // void _loadMoreUserBoards(String userID, {bool reset = false}) {
  //   try {
  //     _boardRepository
  //         .streamUserBoards(userID, pageSize: _pageSize, page: _currentPage)
  //         .listen(
  //       (boards) {
  //         if (boards.length < _pageSize) {
  //           _hasMore = false;
  //         }
  //         if (reset) {
  //           emit(state.fromBoardsLoaded(boards));
  //         } else {
  //           emit(state.fromBoardsLoaded(List.of(state.boards)..addAll(boards)));
  //         }
  //       },
  //       onError: (error) {
  //         emit(state.fromEmpty());
  //       },
  //     );
  //   } on BoardFailure catch (failure) {
  //     emit(state.fromFailure(failure));
  //   }
  // }

  // void streamUserSavedBoards(String userID) {
  //   emit(state.fromLoading());
  //   _currentPage = 0;
  //   _hasMore = true;
  //   _loadMoreUserSavedBoards(userID, reset: true);
  // }

  // void loadMoreUserSavedBoards(String userID) {
  //   if (_hasMore) {
  //     _currentPage++;
  //     _loadMoreUserSavedBoards(userID);
  //   }
  // }

  // void _loadMoreUserSavedBoards(String userID, {bool reset = false}) {
  //   try {
  //     _boardRepository
  //         .streamUserSavedBoards(
  //       userID,
  //       pageSize: _pageSize,
  //       page: _currentPage,
  //     )
  //         .listen(
  //       (boards) {
  //         if (boards.length < _pageSize) {
  //           _hasMore = false;
  //         }
  //         if (reset) {
  //           emit(state.fromBoardsLoaded(boards));
  //         } else {
  //           emit(state.fromBoardsLoaded(List.of(state.boards)..addAll(boards)));
  //         }
  //       },
  //       onError: (error) {
  //         emit(state.fromEmpty());
  //       },
  //     );
  //   } on BoardFailure catch (failure) {
  //     emit(state.fromFailure(failure));
  //   }
  // }

  Future<void> updateTags(String boardId, List<String> tags) async {
    await _tagRepository.updateBoardTags(boardId: boardId, tags: tags);
  }

  Future<void> editField(String boardId, String field, dynamic data) async {
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
    String boardId,
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

  BoardState fromEmpty() => copyWith(status: BoardStatus.empty);

  BoardState fromDeleted() => copyWith(status: BoardStatus.deleted);

  BoardState fromUpdated() => copyWith(status: BoardStatus.updated);

  BoardState fromBoardLoaded(Board board, List<String> tags) => copyWith(
        status: BoardStatus.loaded,
        board: board,
        tags: tags,
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
