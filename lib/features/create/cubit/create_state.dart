part of 'create_cubit.dart';

/// Represents the different states a create operation can be in.
enum CreateStatus {
  /// defaults
  initial,
  empty,
  loaded,
  loading,
  failure,
}

/// Represents the state of creating-related operations.
final class CreateState extends Equatable {
  /// Private constructor for creating [CreateState] instances.
  const CreateState._({
    this.status = CreateStatus.initial,
    this.boardFailure = BoardFailure.empty,
    this.postFailure = PostFailure.empty,
    this.title = '',
    this.description = '',
    this.tags = '',
    this.image,
    this.docId,
  });

  /// Creates an initial [CreateState].
  const CreateState.initial() : this._();

  final CreateStatus status;
  final BoardFailure boardFailure;
  final PostFailure postFailure;

  final String title;
  final String description;
  final String tags;
  final File? image;
  final int? docId;

  // Rebuilds the widget when the props change
  @override
  List<Object?> get props => [
        status,
        boardFailure,
        postFailure,
        title,
        description,
        tags,
        image,
        docId,
      ];

  /// Creates a new [CreateState] with updated fields.
  /// Any parameter that is not provided will retain its current value.
  CreateState copyWith({
    CreateStatus? status,
    BoardFailure? boardFailure,
    PostFailure? postFailure,
    String? title,
    String? description,
    String? tags,
    File? image,
    int? docId,
  }) {
    return CreateState._(
      status: status ?? this.status,
      boardFailure: boardFailure ?? this.boardFailure,
      postFailure: postFailure ?? this.postFailure,
      title: title ?? this.title,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      image: image ?? this.image,
      docId: docId ?? this.docId,
    );
  }
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

  CreateState fromUploadedPostImage(File? image) =>
      copyWith(status: CreateStatus.loaded, image: image);

  CreateState fromUploadedBoardImage(File? image) =>
      copyWith(status: CreateStatus.loaded, image: image);

  CreateState fromChangedTitle(String title) =>
      copyWith(status: CreateStatus.loaded, title: title);

  CreateState fromChangedDescription(String description) =>
      copyWith(status: CreateStatus.loaded, description: description);

  CreateState fromChangedTags(String tags) =>
      copyWith(status: CreateStatus.loaded, tags: tags);

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
