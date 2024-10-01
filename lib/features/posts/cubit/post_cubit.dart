import 'package:app_core/app_core.dart';
import 'package:post_repository/post_repository.dart';
import 'package:tag_repository/tag_repository.dart';

// State definitions
part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit({
    required PostRepository postRepository,
    required TagRepository tagRepository,
  })  : _postRepository = postRepository,
        _tagRepository = tagRepository,
        super(const PostState.initial());

  final PostRepository _postRepository;
  final TagRepository _tagRepository;

  int _currentPage = 0;
  final int _pageSize = 10;
  bool _hasMore = true;

  Future<void> fetchPost(String postId) async {
    emit(state.fromLoading());
    try {
      final post = await _postRepository.fetchPost(postId: postId);
      final tags = await _tagRepository.readPostTags(uuid: postId);
      emit(state.fromPostLoaded(post, tags));
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  Future<void> shufflePostList(String boardId) async {
    emit(state.fromLoading());
    try {
      final posts = await _postRepository.fetchBoardPosts(boardId: boardId);
      if (posts.isEmpty) {
        emit(state.fromEmpty());
        return;
      }
      posts.shuffle();
      emit(state.fromPostsLoaded(posts));
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  // void streamPost(String postId) {
  //   emit(state.fromLoading());
  //   try {
  //     _postRepository.streamPost(postId).listen(
  //       (snapshot) {
  //         emit(state.fromPostLoaded(snapshot));
  //       },
  //       onError: (dynamic error) {
  //         emit(state.fromFailure(PostFailure.fromGetPost()));
  //       },
  //     );
  //   } on PostFailure catch (failure) {
  //     emit(state.fromFailure(failure));
  //   }
  // }

  // void streamPosts(String type, String docID) {
  //   if (type == 'user') {
  //     streamUserPosts(docID);
  //   } else if (type == 'likes') {
  //     streamUserLikedPosts(docID);
  //   } else if (type == 'board') {
  //     streamBoardPosts(docID);
  //   }
  //   // error
  // }

  // void loadMorePosts(String type, String docID) {
  //   if (type == 'user') {
  //     loadMoreUserPosts(docID);
  //   } else if (type == 'likes') {
  //     loadMoreUserLikedPosts(docID);
  //   } else if (type == 'board') {
  //     loadMoreBoardPosts(docID);
  //   }
  //   // error
  // }

  // bool hasMore() {
  //   return _hasMore;
  // }

  // void streamUserPosts(String userId) {
  //   emit(state.fromLoading());
  //   _currentPage = 0;
  //   _hasMore = true;
  //   _loadMoreUserPosts(userId, reset: true);
  // }

  // void loadMoreUserPosts(String userId) {
  //   if (_hasMore) {
  //     _currentPage++;
  //     _loadMoreUserPosts(userId);
  //   }
  // }

  // void _loadMoreUserPosts(String userId, {bool reset = false}) {
  //   try {
  //     _postRepository
  //         .streamUserPosts(userId, pageSize: _pageSize, page: _currentPage)
  //         .listen(
  //       (posts) {
  //         if (posts.length < _pageSize) {
  //           _hasMore = false;
  //         }
  //         if (reset) {
  //           emit(state.fromPostsLoaded(posts));
  //         } else {
  //           emit(state.fromPostsLoaded(List.of(state.posts)..addAll(posts)));
  //         }
  //       },
  //       onError: (error) {
  //         emit(state.fromEmpty());
  //       },
  //     );
  //   } on PostFailure catch (failure) {
  //     emit(state.fromFailure(failure));
  //   }
  // }

  // void streamUserLikedPosts(String userId) {
  //   emit(state.fromLoading());
  //   _currentPage = 0;
  //   _hasMore = true;
  //   _loadMoreUserLikedPosts(userId, reset: true);
  // }

  // void loadMoreUserLikedPosts(String userId) {
  //   if (_hasMore) {
  //     _currentPage++;
  //     _loadMoreUserLikedPosts(userId);
  //   }
  // }

  // void _loadMoreUserLikedPosts(String userId, {bool reset = false}) {
  //   try {
  //     _postRepository
  //         .streamUserLikedPosts(userId, pageSize: _pageSize, page: _currentPage)
  //         .listen(
  //       (posts) {
  //         if (posts.length < _pageSize) {
  //           _hasMore = false;
  //         }
  //         if (reset) {
  //           emit(state.fromPostsLoaded(posts));
  //         } else {
  //           emit(state.fromPostsLoaded(List.of(state.posts)..addAll(posts)));
  //         }
  //       },
  //       onError: (error) {
  //         emit(state.fromEmpty());
  //       },
  //     );
  //   } on PostFailure catch (failure) {
  //     emit(state.fromFailure(failure));
  //   }
  // }

  // void streamBoardPosts(String boardID) {
  //   emit(state.fromLoading());
  //   _currentPage = 0;
  //   _hasMore = true;
  //   _loadMoreBoardPosts(boardID, reset: true);
  // }

  // void loadMoreBoardPosts(String boardID) {
  //   if (_hasMore) {
  //     _currentPage++;
  //     _loadMoreBoardPosts(boardID);
  //   }
  // }

  // void _loadMoreBoardPosts(String boardID, {bool reset = false}) {
  //   try {
  //     _postRepository
  //         .streamBoardPosts(boardID, pageSize: _pageSize, page: _currentPage)
  //         .listen(
  //       (posts) {
  //         if (posts.length < _pageSize) {
  //           _hasMore = false;
  //         }
  //         if (reset) {
  //           emit(state.fromPostsLoaded(posts));
  //         } else {
  //           emit(state.fromPostsLoaded(List.of(state.posts)..addAll(posts)));
  //         }
  //       },
  //       onError: (error) {
  //         emit(state.fromEmpty());
  //       },
  //     );
  //   } on PostFailure catch (failure) {
  //     emit(state.fromFailure(failure));
  //   }
  // }

  // void streamAllPosts() {
  //   emit(state.fromLoading());
  //   try {
  //     _postRepository.streamPosts().listen(
  //       (posts) {
  //         emit(state.fromPostsLoaded(posts));
  //       },
  //       onError: (dynamic error) {
  //         emit(state.fromEmpty());
  //       },
  //     );
  //   } on PostFailure catch (failure) {
  //     emit(state.fromFailure(failure));
  //   }
  // }

  Future<void> editField(String postId, String field, dynamic data) async {
    emit(state.fromLoading());
    await _postRepository.updatePost(postId: postId, field: field, data: data);
    emit(state.fromUpdate());
  }

  Future<void> updateTags(String postId, List<String> tags) async {
    await _tagRepository.updatePostTags(postId: postId, tags: tags);
  }

  Future<void> deletePost(
    String userId,
    String postId,
    String photoURL,
  ) async {
    emit(state.fromLoading());
    try {
      await _postRepository.deletePost(postId: postId);
      emit(state.fromDeleted());
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }
}
