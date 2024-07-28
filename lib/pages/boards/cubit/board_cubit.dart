import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:boards_repository/boards_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

// State definitions
part 'board_state.dart';

class BoardCubit extends Cubit<BoardState> {
  BoardCubit({
    required BoardsRepository boardsRepository,
    required UserRepository userRepository,
  })  : _boardsRepository = boardsRepository,
        _userRepository = userRepository,
        super(const BoardState.initial());

  final BoardsRepository _boardsRepository;
  final UserRepository _userRepository;

  int index = 0;

  bool isOwner(String boardUserID, String currentUserID) {
    return boardUserID == currentUserID;
  }

  User getUser() {
    return _userRepository.getCurrentUser();
  }

  Future<void> getBoard(String boardID) async {
    emit(state.fromBoardLoading());
    try {
      final board = await _boardsRepository.readBoard(boardID);
      if (board.isEmpty) {
        emit(state.fromBoardEmpty());
        return;
      }
      emit(state.fromBoardLoaded(board));
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }

  Future<void> fetchBoardItems(String boardID) async {
    emit(state.fromBoardLoading());
    try {
      final items = await _boardsRepository.readItems(boardID);
      if (items.isEmpty) {
        emit(state.fromBoardEmpty());
        return;
      }
      emit(state.fromListLoaded(items));
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }

  void streamItems(String boardID) {
    emit(state.fromBoardLoading());
    try {
      _boardsRepository.readItemsStream(boardID).listen(
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
      _boardsRepository.readBoardStream(boardID).listen(
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
      _userRepository.streamBoards(userID).listen(
        (snapshot) {
          emit(state.fromListLoaded(snapshot));
        },
        onError: (dynamic error) {
          emit(state.fromBoardEmpty());
        },
      );
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }

  Future<void> shuffleItemList(String boardID) async {
    emit(state.fromBoardLoading());
    try {
      final items = await _boardsRepository.readItems(boardID);
      if (items.isEmpty) {
        emit(state.fromBoardEmpty());
        return;
      }
      items.shuffle();
      emit(state.fromListLoaded(items));
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }

  Future<void> editField(String boardID, String field, String data) async {
    await _boardsRepository.updateField(boardID, field, data);
  }

  Future<void> toggleLike(
    String userID,
    String boardID, {
    required bool isSelected,
  }) async {
    emit(state.fromBoardLoading());
    try {
      await _boardsRepository.updateBoardLikes(
        userID: userID,
        boardID: boardID,
        isLiked: isSelected,
      );
      // await getBoard(boardID);
      emit(state.fromBoardToggle(selected: isSelected));
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }

  Future<void> toggleSelection(
    String boardID,
    String itemID, {
    required bool isSelected,
  }) async {
    emit(state.fromBoardLoading());
    try {
      await _boardsRepository.updateBoardItems(
        boardID: boardID,
        itemID: itemID,
        isSelected: isSelected,
      );
      await getBoard(boardID);
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }

  void skipItem() {
    if (state.isLoaded) {
      final items = state.items;
      if (index + 1 < items.length) {
        index++;
        emit(state.fromListLoaded(items));
      }
    }
  }

  void incrementIndex() {
    final newIndex = state.index + 1;
    print('Incrementing index to: $newIndex');
    emit(state.copyWith(index: newIndex));
  }

  void decrementIndex() {
    final newIndex = state.index - 1;
    print('Decrementing index to: $newIndex');
    emit(state.copyWith(index: newIndex));
  }

  Future<void> createBoard({
    required String userID,
    required String title,
    required String description,
    required File? imageFile,
  }) async {
    emit(state.fromBoardCreating());
    try {
      final docID = await _boardsRepository.createBoard(
        Board(
          title: title,
          description: description,
          uid: 'userId', // Replace with actual user ID
        ),
        userID,
      );
      if (imageFile != null) {
        await _boardsRepository.uploadImage(imageFile, docID);
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
    try {
      await _boardsRepository.deleteBoard(userID, boardID, photoURL);
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

  BoardState fromBoardCreating() => copyWith(status: BoardStatus.creating);

  BoardState fromBoardCreated() => copyWith(status: BoardStatus.created);

  BoardState fromBoardLoaded(Board board) => copyWith(
        status: BoardStatus.loaded,
        board: board,
      );

  BoardState fromListLoaded(List<String> items) => copyWith(
        status: BoardStatus.loaded,
        items: items,
        index: 0,
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
