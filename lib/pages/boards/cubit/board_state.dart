part of 'board_cubit.dart';

enum BoardStatus {
  initial,
  loading,
  empty,
  loaded,
  deleted,
  created,
  creating,
  failure,
}

final class BoardState extends Equatable {
  const BoardState._({
    this.status = BoardStatus.initial,
    this.board = Board.empty,
    this.posts = const [],
    this.failure = BoardFailure.empty,
    this.selected = false,
    this.index = 0,
  });

  const BoardState.initial() : this._();

  final BoardStatus status;
  final Board board;
  final List<String> posts;
  final BoardFailure failure;
  final bool selected;
  final int index;

  @override
  List<Object?> get props => [
        status,
        board,
        posts,
        failure,
        selected,
        index,
      ];

  BoardState copyWith({
    BoardStatus? status,
    Board? board,
    List<String>? posts,
    BoardFailure? failure,
    bool? selected,
    int? index,
  }) {
    return BoardState._(
      status: status ?? this.status,
      board: board ?? this.board,
      posts: posts ?? this.posts,
      failure: failure ?? this.failure,
      selected: selected ?? this.selected,
      index: index ?? this.index,
    );
  }
}

extension BoardStateExtensions on BoardState {
  bool get isEmpty => status == BoardStatus.empty;
  bool get isLoaded => status == BoardStatus.loaded;
  bool get isLoading => status == BoardStatus.loading;
  bool get isFailure => status == BoardStatus.failure;
  bool get isCreated => status == BoardStatus.created;
  bool get isCreating => status == BoardStatus.creating;
  bool get isDeleted => status == BoardStatus.deleted;
  bool get canIncrement => index < posts.length - 1;
  bool get canDecrement => index > 0;
}
