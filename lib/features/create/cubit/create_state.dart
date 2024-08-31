part of 'create_cubit.dart';

enum CreateStatus {
  initial,
  loading,
  loadingMore,
  empty,
  loaded,
  created,
  creating,
  deleted,
  updated,
  failure,
}

final class CreateState extends Equatable {
  const CreateState._({
    this.status = CreateStatus.initial,
    this.boardFailure = BoardFailure.empty,
    this.postFailure = PostFailure.empty,
  });

  // initial state
  const CreateState.initial() : this._();

  final CreateStatus status;
  final BoardFailure boardFailure;
  final PostFailure postFailure;

  // rebuilds the app when the props change
  @override
  List<Object?> get props => [
        status,
        boardFailure,
        postFailure,
      ];

  CreateState copyWith({
    CreateStatus? status,
    BoardFailure? boardFailure,
    PostFailure? postFailure,
  }) {
    return CreateState._(
      status: status ?? this.status,
      boardFailure: boardFailure ?? this.boardFailure,
      postFailure: postFailure ?? this.postFailure,
    );
  }
}

extension CreateStateExtensions on CreateState {
  bool get isEmpty => status == CreateStatus.empty;
  bool get isLoaded => status == CreateStatus.loaded;
  bool get isLoading => status == CreateStatus.loading;
  bool get isFailure => status == CreateStatus.failure;
  bool get isCreated => status == CreateStatus.created;
  bool get isCreating => status == CreateStatus.creating;
}

extension _CreateStateExtensions on CreateState {
  CreateState fromLoading() => copyWith(status: CreateStatus.loading);

  CreateState fromCreated() => copyWith(status: CreateStatus.created);

  CreateState fromPostFailure(PostFailure failure) => copyWith(
        status: CreateStatus.failure,
        postFailure: failure,
      );
  CreateState fromBoardFailure(BoardFailure failure) => copyWith(
        status: CreateStatus.failure,
        boardFailure: failure,
      );
}
