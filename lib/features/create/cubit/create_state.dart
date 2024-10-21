part of 'create_cubit.dart';

/// Represents the different states a create operation can be in.
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

/// Represents the state of creating-related operations.
final class CreateState extends Equatable {
  /// Private constructor for creating [CreateState] instances.
  const CreateState._({
    this.status = CreateStatus.initial,
    this.boardFailure = BoardFailure.empty,
    this.postFailure = PostFailure.empty,
  });

  /// Creates an initial [CreateState].
  const CreateState.initial() : this._();

  final CreateStatus status;
  final BoardFailure boardFailure;
  final PostFailure postFailure;

  // Rebuilds the widget when the props change
  @override
  List<Object?> get props => [
        status,
        boardFailure,
        postFailure,
      ];

  /// Creates a new [CreateState] with updated fields.
  /// Any parameter that is not provided will retain its current value.
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

/// Extension methods for convenient state checks.
extension CreateStateExtensions on CreateState {
  bool get isEmpty => status == CreateStatus.empty;
  bool get isLoaded => status == CreateStatus.loaded;
  bool get isLoading => status == CreateStatus.loading;
  bool get isFailure => status == CreateStatus.failure;
  bool get isCreated => status == CreateStatus.created;
  bool get isCreating => status == CreateStatus.creating;
}

/// Extension methods for creating new [CreateState] instances.
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
