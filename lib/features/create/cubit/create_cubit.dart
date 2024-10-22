import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:board_repository/board_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:tag_repository/tag_repository.dart';

// State definitions
part 'create_state.dart';

/// Manages the state and logic for post creation-related operations.
class CreateCubit extends Cubit<CreateState> {
  /// Creates a new instance of [CreateCubit].
  /// Requires a [PostRepository], [BoardRepository], and [TagRepository]
  ///   to handle data operations.
  CreateCubit({
    required PostRepository postRepository,
    required BoardRepository boardRepository,
    required TagRepository tagRepository,
  })  : _postRepository = postRepository,
        _boardRepository = boardRepository,
        _tagRepository = tagRepository,
        super(const CreateState.initial());

  final BoardRepository _boardRepository;
  final PostRepository _postRepository;
  final TagRepository _tagRepository;

  /// Public setters for image uploads
  void uploadPostImage(File? image) => emit(state.fromUploadedPostImage(image));
  void uploadBoardImage(File? image) =>
      emit(state.fromUploadedBoardImage(image));
  void skipPostImage() => emit(state.fromSkipPostImage());
  void skipBoardImage() => emit(state.fromSkipBoardImage());

  /// Uploads the post to the cubit's state
  void createPost({required Post post}) =>
      emit(state.fromCreatedPostDetails(post));

  /// Uploads the board to the cubit's state
  void createBoard({required Board board}) =>
      emit(state.fromCreatedBoardDetails(board));

  /// Submits the new post to the database
  /// Requires the current user's [userId]
  Future<void> sumbitPost({required String userId}) async {
    emit(state.fromLoading());
    try {
      final docId = await _postRepository.uploadPost(data: state.post.toJson());
      final tags = state.post.tags.split('+');
      if (tags.isNotEmpty) {
        tags.map(
          (tag) => _tagRepository.createPostTag(tagName: tag, id: docId),
        );
      }
      if (state.image != null) {
        await submitPostImage(
          docId: docId,
          userId: userId,
          image: state.image,
        );
      }
      emit(state.fromCreated(docId));
    } on PostFailure catch (failure) {
      emit(state.fromPostFailure(failure));
    }
  }

  /// Creates an image for the new post
  /// Uploads the [image] to supabase
  /// Requires [userId] and [docId] to handle the correct path
  Future<void> submitPostImage({
    required String userId,
    required int docId,
    required File? image,
  }) async {
    emit(state.fromLoading());
    try {
      final path = '$userId/image_$docId.jpeg';
      if (image != null) {
        final url = await Supabase.instance.client.uploadFile(
          collection: 'posts',
          path: path,
          file: image.readAsBytesSync(),
        );
        await _postRepository.updatePost(
          field: Post.photoUrlConverter,
          postId: docId,
          data: url,
        );
      }
    } on PostFailure catch (failure) {
      emit(state.fromPostFailure(failure));
    }
  }

  /// Submits the new board to the database
  /// Requires the current user's [userId]
  Future<void> sumbitBoard({required String userId}) async {
    emit(state.fromLoading());
    try {
      final docId = await _boardRepository.uploadBoard(
        data: state.board.toJson(),
      );
      if (state.image != null) {
        await submitBoardImage(
          docId: docId,
          userId: userId,
          image: state.image,
        );
      }
      emit(state.fromCreated(docId));
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }

  /// Creates an image for the new board
  /// Uploads the [image] to supabase
  /// Requires [userId] and [docId] to handle the correct path
  Future<void> submitBoardImage({
    required String userId,
    required int docId,
    required File? image,
  }) async {
    emit(state.fromLoading());
    try {
      final path = '$userId/image_$docId.jpeg';
      if (image != null) {
        final url = await Supabase.instance.client.uploadFile(
          collection: 'posts',
          path: path,
          file: image.readAsBytesSync(),
        );
        await _boardRepository.updateBoard(
          field: Post.photoUrlConverter,
          boardId: docId,
          data: url,
        );
      }
    } on PostFailure catch (failure) {
      emit(state.fromPostFailure(failure));
    }
  }
}
