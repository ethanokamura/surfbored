import 'dart:io';
import 'package:api_client/api_client.dart';
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

  bool isOwner(String boardUserID, String currentUserID) {
    return boardUserID == currentUserID;
  }

  Future<void> getBoard(String boardID) async {
    emit(state.fromBoardLoading());
    try {
      final board = await _boardRepository.fetchBoard(boardID);
      if (board.isEmpty) {
        emit(state.fromBoardEmpty());
        return;
      }
      emit(state.fromBoardLoaded(board));
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }

  Future<void> fetchBoardPosts(String boardID) async {
    emit(state.fromBoardLoading());
    try {
      final posts = await _boardRepository.fetchPosts(boardID);
      if (posts.isEmpty) {
        emit(state.fromBoardEmpty());
        return;
      }
      emit(state.fromListLoaded(posts));
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }

  void streamPosts(String boardID) {
    emit(state.fromBoardLoading());
    try {
      _boardRepository.streamPosts(boardID).listen(
        (snapshot) {
          emit(state.fromListLoaded(snapshot));
        },
        onError: (dynamic error) {
          emit(state.fromBoardFailure(BoardFailure.fromGetBoard()));
        },
      );
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }

  void streamBoard(String boardID) {
    emit(state.fromBoardLoading());
    try {
      _boardRepository.streamBoard(boardID).listen(
        (snapshot) {
          emit(state.fromBoardLoaded(snapshot));
        },
        onError: (dynamic error) {
          emit(state.fromBoardFailure(BoardFailure.fromGetBoard()));
        },
      );
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }

  void streamUserBoards(String userID) {
    emit(state.fromBoardLoading());
    try {
      _boardRepository.streamUserBoards(userID).listen(
        (snapshot) {
          emit(state.fromBoardsLoaded(snapshot));
        },
        onError: (dynamic error) {
          emit(state.fromBoardEmpty());
        },
      );
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }

  Future<void> shufflePostList(String boardID) async {
    emit(state.fromBoardLoading());
    try {
      final posts = await _boardRepository.fetchPosts(boardID);
      if (posts.isEmpty) {
        emit(state.fromBoardEmpty());
        return;
      }
      posts.shuffle();
      emit(state.fromListLoaded(posts));
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }

  Future<void> editField(String boardID, String field, dynamic data) async {
    emit(state.fromBoardLoading());
    await _boardRepository.updateField(boardID, {field: data});
    emit(state.fromBoardUpdated());
  }

  Future<void> toggleLike(
    String userID,
    String boardID, {
    required bool isSelected,
  }) async {
    emit(state.fromBoardLoading());
    try {
      await _boardRepository.updateBoardSaves(
        userID: userID,
        boardID: boardID,
        isLiked: isSelected,
      );
      emit(state.fromBoardToggle(selected: isSelected));
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }

  Future<void> toggleSelection(
    String boardID,
    String postID, {
    required bool isSelected,
  }) async {
    emit(state.fromBoardLoading());
    try {
      await _boardRepository.updateBoardPosts(
        boardID: boardID,
        postID: postID,
        isSelected: isSelected,
      );
      await getBoard(boardID);
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }

  void incrementIndex() {
    final newIndex = state.index + 1;
    emit(state.copyWith(index: newIndex));
  }

  void decrementIndex() {
    final newIndex = state.index - 1;
    emit(state.copyWith(index: newIndex));
  }

  Future<void> createBoard({
    required String userID,
    required String title,
    required String description,
    required File? imageFile,
  }) async {
    emit(state.fromBoardLoading());
    try {
      final docID = await _boardRepository.createBoard(
        Board(
          title: title,
          description: description,
          uid: 'userId', // Replace with actual user ID
        ),
        userID,
      );
      if (imageFile != null) {
        await FirebaseFirestore.instance
            .uploadImage('boards', docID, imageFile);
      }
      emit(state.fromBoardCreated());
      await getBoard(docID);
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }

  Future<void> deleteBoard(
    String userID,
    String boardID,
    String photoURL,
  ) async {
    emit(state.fromBoardLoading());
    try {
      await _boardRepository.deleteBoard(userID, boardID, photoURL);
      emit(state.fromBoardDeleted());
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }
}

extension _BoardStateExtensions on BoardState {
  BoardState fromBoardLoading() => copyWith(status: BoardStatus.loading);

  BoardState fromBoardEmpty() => copyWith(status: BoardStatus.empty);

  BoardState fromBoardDeleted() => copyWith(status: BoardStatus.deleted);

  BoardState fromBoardCreated() => copyWith(status: BoardStatus.created);

  BoardState fromBoardUpdated() => copyWith(status: BoardStatus.updated);

  BoardState fromBoardLoaded(Board board) => copyWith(
        status: BoardStatus.loaded,
        board: board,
      );

  BoardState fromListLoaded(List<String> posts) => copyWith(
        status: BoardStatus.loaded,
        posts: posts,
        index: 0,
      );

  BoardState fromBoardsLoaded(List<Board> boards) => copyWith(
        status: BoardStatus.loaded,
        boards: boards,
      );

  BoardState fromBoardToggle({required bool selected}) => copyWith(
        status: BoardStatus.loaded,
        selected: selected,
      );

  BoardState fromBoardFailure(BoardFailure failure) => copyWith(
        status: BoardStatus.failure,
        failure: failure,
      );
}
