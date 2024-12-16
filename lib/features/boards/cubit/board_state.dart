part of 'board_cubit.dart';

/// Represents the different states a board operation can be in.
enum BoardStatus {
  initial,
  loading,
  empty,
  loaded,
  deleted,
  updated,
  failure,
}

/// Represents the state of board-related operations.
final class BoardState extends Equatable {
  /// Private constructor for creating BoardState instances.
  const BoardState._({
    this.status = BoardStatus.initial,
    this.board = Board.empty,
    this.boards = const [],
    this.failure = BoardFailure.empty,
    this.selected = false,
    this.photoUrl = '',
    this.index = 0,
  });

  /// Creates an initial BoardState.
  const BoardState.initial() : this._();

  final BoardStatus status;
  final Board board;
  final List<Board> boards;
  final BoardFailure failure;
  final bool selected;
  final String photoUrl;
  final int index;

  // Rebuilds the widget when the props change
  @override
  List<Object?> get props => [
        status,
        board,
        boards,
        failure,
        selected,
        photoUrl,
        index,
      ];

  /// Creates a new BoardState with updated fields.
  /// Any parameter that is not provided will retain its current value.
  BoardState copyWith({
    BoardStatus? status,
    Board? board,
    List<Board>? boards,
    BoardFailure? failure,
    String? photoUrl,
    bool? selected,
    int? index,
  }) {
    return BoardState._(
      status: status ?? this.status,
      board: board ?? this.board,
      boards: boards ?? this.boards,
      failure: failure ?? this.failure,
      photoUrl: photoUrl ?? this.photoUrl,
      selected: selected ?? this.selected,
      index: index ?? this.index,
    );
  }
}

/// Extension methods for convenient state checks.
extension BoardStateExtensions on BoardState {
  bool get isEmpty => status == BoardStatus.empty;
  bool get isLoaded => status == BoardStatus.loaded;
  bool get isLoading => status == BoardStatus.loading;
  bool get isFailure => status == BoardStatus.failure;
  bool get isDeleted => status == BoardStatus.deleted;
  bool get isUpdated => status == BoardStatus.updated;
}

/// Extension methods for creating new [BoardState] instances.
extension _BoardStateExtensions on BoardState {
  BoardState fromLoading() => copyWith(status: BoardStatus.loading);

  BoardState fromEmpty() => copyWith(boards: [], status: BoardStatus.empty);

  BoardState fromDeleted() => copyWith(status: BoardStatus.deleted);

  BoardState fromUpdated() => copyWith(status: BoardStatus.updated);

  BoardState fromBoardLoaded(Board board) => copyWith(
        status: BoardStatus.loaded,
        board: board,
      );

  BoardState fromSetImage(String url) =>
      copyWith(photoUrl: url, status: BoardStatus.loaded);

  BoardState fromBoardsLoaded(List<Board> boards) => copyWith(
        status: BoardStatus.loaded,
        boards: boards,
      );

  BoardState fromFailure(BoardFailure failure) => copyWith(
        status: BoardStatus.failure,
        failure: failure,
      );
}
