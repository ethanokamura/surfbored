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

  /// Creates a new post!
  Future<void> createPost({
    required String userId,
    required String title,
    required String description,
    required String link,
    required List<String> tags,
    required bool isPublic,
    required File? imageFile,
  }) async {
    emit(state.fromLoading());
    try {
      final docId = await _postRepository.createPost(
        post: Post(
          title: title,
          creatorId: userId,
          description: description,
          tags: tags.join('+'),
          isPublic: isPublic,
          link: link,
        ),
      );

      if (tags.isNotEmpty) {
        tags.map(
          (tag) => _tagRepository.createPostTag(tagName: tag, id: docId),
        );
      }

      final path = '$userId/image_$docId.jpeg';
      if (imageFile != null) {
        final url = await Supabase.instance.client.uploadFile(
          collection: 'posts',
          path: path,
          file: imageFile.readAsBytesSync(),
        );
        await _postRepository.updatePost(
          field: Post.photoUrlConverter,
          postId: docId,
          data: url,
        );
      }
      emit(state.fromCreated());
    } on PostFailure catch (failure) {
      emit(state.fromPostFailure(failure));
    }
  }

  /// Creates a new board!
  Future<void> createBoard({
    required String userId,
    required String title,
    required String description,
    required bool isPublic,
    required File? imageFile,
  }) async {
    emit(state.fromLoading());
    try {
      final docId = await _boardRepository.createBoard(
        board: Board(
          creatorId: userId,
          title: title,
          isPublic: isPublic,
          description: description,
        ),
      );
      final path = '$userId/image_$docId.jpeg';
      if (imageFile != null) {
        final url = await Supabase.instance.client.uploadFile(
          collection: 'boards',
          path: path,
          file: imageFile.readAsBytesSync(),
        );
        await _boardRepository.updateBoard(
          field: Board.photoUrlConverter,
          boardId: docId,
          data: url,
        );
      }
      emit(state.fromCreated());
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }
}
