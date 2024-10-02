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
  int currentPage = 0;
  final int pageSize = 10;
  bool hasMore = true;

  Future<void> fetchBoard(int boardId) async {
    emit(state.fromLoading());
    try {
      final board = await _boardRepository.fetchBoard(boardId: boardId);
      final tags = await _tagRepository.fetchBoardTags(id: boardId);
      emit(state.fromBoardLoaded(board, tags));
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
      currentPage = 0;
      hasMore = true;
      emit(state.fromEmpty());
    }

    if (!hasMore) return;

    emit(state.fromLoading());
    try {
      final boards = await _boardRepository.fetchUserBoards(
        userId: userId,
        offset: currentPage * pageSize,
        limit: pageSize,
      );

      if (boards.isEmpty) {
        hasMore = false; // No more boards to load
        emit(state.fromEmpty());
      } else {
        currentPage++; // Increment the page number
        emit(state.fromBoardsLoaded([...state.boards, ...boards]));
      }
    } on BoardFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  Stream<List<Board>> streamUserBoards(String userId) =>
      _boardRepository.streamUserBoards(userId: userId);

  Future<void> updateTags(int boardId, List<String> tags) async {
    await _tagRepository.updateBoardTags(boardId: boardId, tags: tags);
  }

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
