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

  int _currentPage = 0;
  final int _pageSize = 10;
  bool _hasMore = true;

  // change to stream?
  Future<void> fetchBoardPosts(String boardID) async {
    emit(state.fromLoading());
    try {
      final posts = await _boardRepository.fetchPosts(boardID);
      if (posts.isEmpty) {
        emit(state.fromEmpty());
        return;
      }
      emit(state.fromPostsLoaded(posts));
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
  }

  Future<void> createBoard({
    required String userID,
    required String title,
    required String description,
    required File? imageFile,
  }) async {
    emit(state.fromLoading());
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
      emit(state.fromCreated());
    } on BoardFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  Future<void> deleteBoard(
    String userID,
    String boardID,
    String photoURL,
  ) async {
    emit(state.fromLoading());
    try {
      await _boardRepository.deleteBoard(userID, boardID, photoURL);
      emit(state.fromDeleted());
    } on BoardFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  Future<void> shufflePostList(String boardID) async {
    emit(state.fromLoading());
    try {
      final posts = await _boardRepository.fetchPosts(boardID);
      if (posts.isEmpty) {
        emit(state.fromEmpty());
        return;
      }
      posts.shuffle();
      emit(state.fromPostsLoaded(posts));
    } on BoardFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }
}

extension _BoardStateExtensions on BoardState {
  BoardState fromLoading() => copyWith(status: BoardStatus.loading);

  BoardState fromEmpty() => copyWith(status: BoardStatus.empty);

  BoardState fromDeleted() => copyWith(status: BoardStatus.deleted);

  BoardState fromCreated() => copyWith(status: BoardStatus.created);

  BoardState fromUpdated() => copyWith(status: BoardStatus.updated);

  BoardState fromBoardLoaded(Board board) => copyWith(
        status: BoardStatus.loaded,
        board: board,
      );

  BoardState fromPostsLoaded(List<String> posts) => copyWith(
        status: BoardStatus.loaded,
        posts: posts,
        index: 0,
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
