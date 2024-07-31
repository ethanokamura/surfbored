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

  int _currentPage = 0;
  final int _pageSize = 10;
  bool _hasMore = true;

  void streamPost(String postID) {
    emit(state.fromLoading());
    try {
      _postRepository.streamPost(postID).listen(
        (snapshot) {
          emit(state.fromPostLoaded(snapshot));
        },
        onError: (dynamic error) {
          emit(state.fromFailure(PostFailure.fromGetPost()));
        },
      );
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  bool hasMore() {
    return _hasMore;
  }

  void streamUserPosts(String userID) {
    emit(state.fromLoading());
    _currentPage = 0;
    _hasMore = true;
    _loadMoreUserPosts(userID, reset: true);
  }

  void loadMoreUserPosts(String userID) {
    if (_hasMore) {
      _currentPage++;
      _loadMoreUserPosts(userID);
    }
  }

  void _loadMoreUserPosts(String userID, {bool reset = false}) {
    try {
      _postRepository
          .streamUserPosts(userID, pageSize: _pageSize, page: _currentPage)
          .listen(
        (posts) {
          if (posts.length < _pageSize) {
            _hasMore = false;
          }
          if (reset) {
            emit(state.fromPostsLoaded(posts));
          } else {
            emit(state.fromPostsLoaded(List.of(state.posts)..addAll(posts)));
          }
        },
        onError: (error) {
          emit(state.fromEmpty());
        },
      );
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  void streamBoardPosts(String boardID) {
    emit(state.fromLoading());
    _currentPage = 0;
    _hasMore = true;
    _loadMoreBoardPosts(boardID, reset: true);
  }

  void loadMoreBoardPosts(String boardID) {
    if (_hasMore) {
      _currentPage++;
      _loadMoreBoardPosts(boardID);
    }
  }

  void _loadMoreBoardPosts(String boardID, {bool reset = false}) {
    try {
      _postRepository
          .streamBoardPosts(boardID, pageSize: _pageSize, page: _currentPage)
          .listen(
        (posts) {
          if (posts.length < _pageSize) {
            _hasMore = false;
          }
          if (reset) {
            emit(state.fromPostsLoaded(posts));
          } else {
            emit(state.fromPostsLoaded(List.of(state.posts)..addAll(posts)));
          }
        },
        onError: (error) {
          emit(state.fromEmpty());
        },
      );
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  void streamAllPosts() {
    emit(state.fromLoading());
    try {
      _postRepository.streamPosts().listen(
        (posts) {
          emit(state.fromPostsLoaded(posts));
        },
        onError: (dynamic error) {
          emit(state.fromEmpty());
        },
      );
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  Future<void> editField(String postID, String field, dynamic data) async {
    emit(state.fromLoading());
    await _postRepository.updateField(postID, {field: data});
    emit(state.fromUpdate());
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
      emit(state.fromFailure(failure));
    }
  }

  Future<void> deletePost(
    String userID,
    String postID,
    String photoURL,
  ) async {
    emit(state.fromLoading());
    try {
      await _postRepository.deletePost(userID, postID, photoURL);
      emit(state.fromDeleted());
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }
}

extension _PostStateExtensions on PostState {
  PostState fromLoading() => copyWith(status: PostStatus.loading);

  PostState fromEmpty() => copyWith(status: PostStatus.empty);

  PostState fromCreated() => copyWith(status: PostStatus.created);

  PostState fromDeleted() => copyWith(status: PostStatus.deleted);

  PostState fromUpdate() => copyWith(status: PostStatus.updated);

  PostState fromPostLoaded(Post post) => copyWith(
        status: PostStatus.loaded,
        post: post,
      );

  PostState fromPostsLoaded(List<Post> posts) => copyWith(
        status: PostStatus.loaded,
        posts: posts,
      );

  PostState fromFailure(PostFailure failure) => copyWith(
        status: PostStatus.failure,
        failure: failure,
      );
}
