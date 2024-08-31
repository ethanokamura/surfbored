import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:board_repository/board_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';

// State definitions
part 'create_state.dart';

class CreateCubit extends Cubit<CreateState> {
  CreateCubit({
    required PostRepository postRepository,
    required BoardRepository boardRepository,
  })  : _postRepository = postRepository,
        _boardRepository = boardRepository,
        super(const CreateState.initial());

  final BoardRepository _boardRepository;
  final PostRepository _postRepository;

  Future<void> create({
    required String type,
    required String userID,
    required String title,
    required String description,
    required List<String> tags,
    required File? imageFile,
  }) async {
    if (type == 'post') {
      await createPost(
        userID: userID,
        title: title,
        description: description,
        tags: tags,
        imageFile: imageFile,
      );
    } else if (type == 'board') {
      await createBoard(
        userID: userID,
        title: title,
        description: description,
        tags: tags,
        imageFile: imageFile,
      );
    }
  }

  Future<void> createPost({
    required String userID,
    required String title,
    required String description,
    required List<String> tags,
    required File? imageFile,
  }) async {
    emit(state.fromLoading());
    try {
      final docID = await _postRepository.createPost(
        Post(
          title: title,
          description: description,
          uid: 'userId', // Replace with actual user ID
          tags: tags,
        ),
        userID,
      );
      if (imageFile != null) {
        await FirebaseFirestore.instance.uploadImage('posts', docID, imageFile);
      }
      emit(state.fromCreated());
    } on PostFailure catch (failure) {
      emit(state.fromPostFailure(failure));
    }
  }

  Future<void> createBoard({
    required String userID,
    required String title,
    required String description,
    required List<String> tags,
    required File? imageFile,
  }) async {
    emit(state.fromLoading());
    try {
      final docID = await _boardRepository.createBoard(
        Board(
          title: title,
          description: description,
          uid: 'userId', // Replace with actual user ID
          tags: tags,
        ),
        userID,
      );
      if (imageFile != null) {
        await FirebaseFirestore.instance
            .uploadImage('boards', docID, imageFile);
      }
      emit(state.fromCreated());
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }
}
