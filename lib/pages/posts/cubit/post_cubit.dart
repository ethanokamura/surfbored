import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';

// State definitions
part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit({
    required PostRepository postRepository,
  })  : _postRepository = postRepository,
        super(const PostState.initial());

  final PostRepository _postRepository;

  bool isOwner(String postUserID, String currentUserID) {
    return postUserID == currentUserID;
  }

  Future<void> getPost(String postID) async {
    emit(state.fromPostLoading());
    try {
      final post = await _postRepository.fetchPost(postID);
      if (post.isEmpty) {
        emit(state.fromPostEmpty());
        return;
      }
      emit(state.fromPostLoaded(post));
    } on PostFailure catch (failure) {
      emit(state.fromPostFailure(failure));
    }
  }

  void streamPost(String postID) {
    emit(state.fromPostLoading());
    try {
      _postRepository.streamPost(postID).listen(
        (snapshot) {
          emit(state.fromPostLoaded(snapshot));
        },
        onError: (dynamic error) {
          emit(state.fromPostFailure(PostFailure.fromGetPost()));
        },
      );
    } on PostFailure catch (failure) {
      emit(state.fromPostFailure(failure));
    }
  }

  void streamUserPosts(String userID) {
    emit(state.fromPostsLoading());
    try {
      _postRepository.streamUserPosts(userID).listen(
        (posts) {
          emit(state.fromPostsLoaded(posts));
        },
        onError: (dynamic error) {
          emit(state.fromPostEmpty());
        },
      );
    } on PostFailure catch (failure) {
      emit(state.fromPostFailure(failure));
    }
  }

  void streamBoardPosts(String boardID) {
    emit(state.fromPostsLoading());
    try {
      _postRepository.streamBoardPosts(boardID).listen(
        (posts) {
          emit(state.fromPostsLoaded(posts));
        },
        onError: (dynamic error) {
          emit(state.fromPostEmpty());
        },
      );
    } on PostFailure catch (failure) {
      emit(state.fromPostFailure(failure));
    }
  }

  void streamAllPosts() {
    emit(state.fromPostsLoading());
    try {
      _postRepository.streamPosts().listen(
        (posts) {
          emit(state.fromPostsLoaded(posts));
        },
        onError: (dynamic error) {
          emit(state.fromPostEmpty());
        },
      );
    } on PostFailure catch (failure) {
      emit(state.fromPostFailure(failure));
    }
  }

  Future<void> editField(String postID, String field, dynamic data) async {
    emit(state.fromPostLoading());
    await _postRepository.updateField(postID, {field: data});
    emit(state.fromPostEdited());
  }

  Future<void> toggleLike(
    String userID,
    String postID, {
    required bool liked,
  }) async {
    emit(state.fromPostLoading());
    try {
      await _postRepository.updateLikes(
        userID: userID,
        postID: postID,
        isLiked: liked,
      );
      emit(state.fromPostToggle(liked: liked));
    } on PostFailure catch (failure) {
      emit(state.fromPostFailure(failure));
    }
  }

  Future<void> createPost({
    required String userID,
    required String title,
    required String description,
    required List<String> tags,
    required File? imageFile,
  }) async {
    emit(state.fromPostCreating());
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
      emit(state.fromPostCreated());
    } on PostFailure catch (failure) {
      emit(state.fromPostFailure(failure));
    }
  }

  Future<void> deletePost(
    String userID,
    String postID,
    String photoURL,
  ) async {
    emit(state.fromPostLoading());
    try {
      await _postRepository.deletePost(userID, postID, photoURL);

      emit(state.fromPostInitial());
      emit(state.fromPostDeleted());
    } on PostFailure catch (failure) {
      emit(state.fromPostFailure(failure));
    }
  }
}

extension _PostStateExtensions on PostState {
  PostState fromPostInitial() => copyWith(status: PostStatus.initial);

  PostState fromPostLoading() => copyWith(status: PostStatus.loading);

  PostState fromPostsLoading() => copyWith(status: PostStatus.loading);

  PostState fromPostEmpty() => copyWith(status: PostStatus.empty);

  PostState fromPostCreating() => copyWith(status: PostStatus.creating);

  PostState fromPostCreated() => copyWith(status: PostStatus.created);

  PostState fromPostDeleted() => copyWith(status: PostStatus.deleted);

  PostState fromPostEdited() => copyWith(status: PostStatus.edited);

  PostState fromPostLoaded(Post post) => copyWith(
        status: PostStatus.loaded,
        post: post,
      );

  PostState fromPostsLoaded(List<Post> posts) => copyWith(
        status: PostStatus.loaded,
        posts: posts,
      );

  PostState fromPostToggle({required bool liked}) => copyWith(
        status: PostStatus.loaded,
        liked: liked,
      );

  PostState fromPostFailure(PostFailure failure) => copyWith(
        status: PostStatus.failure,
        failure: failure,
      );
}
