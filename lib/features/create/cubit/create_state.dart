part of 'create_cubit.dart';

/// Represents the different states a create operation can be in.
enum CreateStatus {
  /// defaults
  initial,
  empty,
  loaded,
  loading,
  failure,

  /// nav
  needsImage,
  needsDetails,
  needsApproval,
}

/// Represents the state of creating-related operations.
final class CreateState extends Equatable {
  /// Private constructor for creating [CreateState] instances.
  const CreateState._({
    this.status = CreateStatus.initial,
    this.boardFailure = BoardFailure.empty,
    this.postFailure = PostFailure.empty,
    this.post = Post.empty,
    this.board = Board.empty,
    this.image,
    this.docId,
  });

  /// Creates an initial [CreateState].
  const CreateState.initial() : this._();

  final CreateStatus status;
  final BoardFailure boardFailure;
  final PostFailure postFailure;
  final Post post;
  final Board board;
  final File? image;
  final int? docId;

  // Rebuilds the widget when the props change
  @override
  List<Object?> get props => [
        status,
        boardFailure,
        postFailure,
        post,
        board,
        image,
        docId,
      ];

  /// Creates a new [CreateState] with updated fields.
  /// Any parameter that is not provided will retain its current value.
  CreateState copyWith({
    CreateStatus? status,
    BoardFailure? boardFailure,
    PostFailure? postFailure,
    Post? post,
    Board? board,
    File? image,
    int? docId,
  }) {
    return CreateState._(
      status: status ?? this.status,
      boardFailure: boardFailure ?? this.boardFailure,
      postFailure: postFailure ?? this.postFailure,
      post: post ?? this.post,
      board: board ?? this.board,
      image: image ?? this.image,
      docId: docId ?? this.docId,
    );
  }
}

/// Extension methods for convenient state checks.
extension CreateStatusExtensions on CreateStatus {
  bool get isInitial => this == CreateStatus.initial;
  bool get needsApproval => this == CreateStatus.needsApproval;
  bool get needsDetails => this == CreateStatus.needsDetails;
  bool get needsImage => this == CreateStatus.needsImage;
}

/// Extension methods for convenient state checks.
extension CreateStateExtensions on CreateState {
  bool get isEmpty => status == CreateStatus.empty;
  bool get isLoaded => status == CreateStatus.loaded;
  bool get isLoading => status == CreateStatus.loading;
  bool get isFailure => status == CreateStatus.failure;
}

/// Extension methods for creating new [CreateState] instances.
extension _CreateStateExtensions on CreateState {
  CreateState fromLoading() => copyWith(status: CreateStatus.loading);

  CreateState fromCreatedPostDetails(Post post) =>
      copyWith(status: CreateStatus.needsApproval, post: post);

  CreateState fromCreatedBoardDetails(Board board) =>
      copyWith(status: CreateStatus.needsApproval, board: board);

  CreateState fromSkipPostImage() =>
      copyWith(status: CreateStatus.needsDetails);

  CreateState fromSkipBoardImage() =>
      copyWith(status: CreateStatus.needsDetails);

  CreateState fromUploadedPostImage(File? image) =>
      copyWith(status: CreateStatus.needsDetails, image: image);

  CreateState fromUploadedBoardImage(File? image) =>
      copyWith(status: CreateStatus.needsDetails, image: image);

  CreateState fromCreated(int docId) =>
      copyWith(status: CreateStatus.loaded, docId: docId);

  CreateState fromPostFailure(PostFailure failure) => copyWith(
        status: CreateStatus.failure,
        postFailure: failure,
      );
  CreateState fromBoardFailure(BoardFailure failure) => copyWith(
        status: CreateStatus.failure,
        boardFailure: failure,
      );
}
