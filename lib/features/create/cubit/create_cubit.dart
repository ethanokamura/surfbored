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

  /// Public setters for post details
  void setTitle(String title) => emit(state.fromChangedTitle(title));
  void setDescription(String description) =>
      emit(state.fromChangedDescription(description));
  void setTags(String tags) => emit(state.fromChangedTags(tags));

  /// Submits the new post to the database
  /// Requires the current user's [userId]
  Future<void> sumbitPost({required String userId}) async {
    emit(state.fromLoading());
    try {
      final post = Post.insert(
        creatorId: userId,
        title: state.title,
        description: state.description,
        tags: state.tags,
      );
      final docId = await _postRepository.uploadPost(data: post);
      final tags = state.tags.split('+');
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
        await _postRepository.updatePostField(
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
      final board = Board.insert(
        creatorId: userId,
        title: state.title,
        description: state.description,
      );
      final docId = await _boardRepository.uploadBoard(data: board);
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
        await _boardRepository.updateBoardField(
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
