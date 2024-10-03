import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:board_repository/board_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:tag_repository/tag_repository.dart';

// State definitions
part 'create_state.dart';

class CreateCubit extends Cubit<CreateState> {
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

  Future<void> create({
    required String type,
    required String userId,
    required String title,
    required String description,
    required String website,
    required List<String> tags,
    required File? imageFile,
  }) async {
    if (type == 'post') {
      await createPost(
        userId: userId,
        title: title,
        description: description,
        website: website,
        tags: tags,
        imageFile: imageFile,
      );
    } else if (type == 'board') {
      await createBoard(
        userId: userId,
        title: title,
        description: description,
        tags: tags,
        imageFile: imageFile,
      );
    }
  }

  Future<void> createPost({
    required String userId,
    required String title,
    required String description,
    required String website,
    required List<String> tags,
    required File? imageFile,
  }) async {
    emit(state.fromLoading());
    try {
      final docId = await _postRepository.createPost(
        post: Post(
          title: title,
          creatorId: userId,
          description: description,
          websiteUrl: website,
        ),
      );

      if (tags.isNotEmpty) {
        tags.map(
          (tag) => _tagRepository.createPostTag(tagName: tag, id: docId),
        );
      }

      final path = '/posts/$userId/image_$docId.jpeg';

      if (imageFile != null) {
        await Supabase.instance.client.uploadFile(
          collection: 'posts',
          path: path,
          file: imageFile.readAsBytesSync(),
        );
      }
      emit(state.fromCreated());
    } on PostFailure catch (failure) {
      emit(state.fromPostFailure(failure));
    }
  }

  Future<void> createBoard({
    required String userId,
    required String title,
    required String description,
    required List<String> tags,
    required File? imageFile,
  }) async {
    emit(state.fromLoading());
    try {
      final docId = await _boardRepository.createBoard(
        board: Board(
          creatorId: userId,
          title: title,
          description: description,
        ),
      );
      if (tags.isNotEmpty) {
        tags.map(
          (tag) => _tagRepository.createBoardTag(tagName: tag, id: docId),
        );
      }
      final path = '/posts/$userId/image_$docId.jpeg';
      if (imageFile != null) {
        await Supabase.instance.client.uploadFile(
          collection: 'boards',
          path: path,
          file: imageFile.readAsBytesSync(),
        );
      }
      emit(state.fromCreated());
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }
}
