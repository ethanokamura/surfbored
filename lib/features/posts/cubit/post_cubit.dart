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

  int currentPage = 0;
  final int pageSize = 10;
  bool hasMore = true;

  Future<void> fetchPost(int postId) async {
    emit(state.fromLoading());
    try {
      final post = await _postRepository.fetchPost(postId: postId);
      final tags = await _tagRepository.fetchPostTags(id: postId);
      emit(state.fromPostLoaded(post, tags));
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  Future<void> fetchAllPosts({bool refresh = false}) async {
    if (refresh) {
      currentPage = 0;
      hasMore = true;
      emit(state.fromEmpty());
    }

    if (!hasMore) return;

    emit(state.fromLoading());
    try {
      final posts = await _postRepository.fetchAllPosts(
        offset: currentPage * pageSize,
        limit: pageSize,
      );

      if (posts.isEmpty) {
        hasMore = false; // No more boards to load
        emit(state.fromEmpty());
      } else {
        currentPage++; // Increment the page number
        state.posts.addAll(posts);
        emit(state.fromPostsLoaded(state.posts));
      }
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  Future<void> fetchBoardPosts(int boardId, {bool refresh = false}) async {
    if (refresh) {
      currentPage = 0;
      hasMore = true;
      emit(state.fromEmpty());
    }

    if (!hasMore) return;

    emit(state.fromLoading());
    try {
      final posts = await _postRepository.fetchBoardPosts(
        boardId: boardId,
        offset: currentPage * pageSize,
        limit: pageSize,
      );

      if (posts.isEmpty) {
        hasMore = false; // No more boards to load
        emit(state.fromEmpty());
      } else {
        currentPage++; // Increment the page number
        state.posts.addAll(posts);
        emit(state.fromPostsLoaded(state.posts));
      }
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  Future<void> fetchUserPosts(String userId, {bool refresh = false}) async {
    if (refresh) {
      currentPage = 0;
      hasMore = true;
      emit(state.fromEmpty());
    }

    if (!hasMore) return;

    emit(state.fromLoading());
    try {
      final posts = await _postRepository.fetchUserPosts(
        userId: userId,
        offset: currentPage * pageSize,
        limit: pageSize,
      );

      if (posts.isEmpty) {
        hasMore = false; // No more boards to load
        emit(state.fromEmpty());
      } else {
        currentPage++; // Increment the page number
        state.posts.addAll(posts);
        emit(state.fromPostsLoaded(state.posts));
      }
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  // Future<void> fetchUserLikedPosts(
  //   String userId, {
  //   bool refresh = false,
  // }) async {
  //   if (refresh) {
  //     currentPage = 0;
  //     hasMore = true;
  //     emit(state.fromEmpty());
  //   }

  //   if (!hasMore) return;

  //   emit(state.fromLoading());
  //   try {
  //     final posts = await _postRepository.fetchUserLikedPosts(
  //       userId: userId,
  //       offset: currentPage * pageSize,
  //       limit: pageSize,
  //     );

  //     if (posts.isEmpty) {
  //       hasMore = false; // No more boards to load
  //       emit(state.fromEmpty());
  //     } else {
  //       currentPage++; // Increment the page number
  //       emit(state.fromPostsLoaded([...state.posts, ...posts]));
  //     }
  //   } on PostFailure catch (failure) {
  //     emit(state.fromFailure(failure));
  //   }
  // }

  Future<void> shufflePostList(int boardId) async {
    emit(state.fromLoading());
    try {
      state.posts.shuffle();
      emit(state.fromPostsLoaded(state.posts));
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  Future<void> editField(int postId, String field, dynamic data) async {
    emit(state.fromLoading());
    await _postRepository.updatePost(postId: postId, field: field, data: data);
    emit(state.fromUpdate());
  }

  Future<void> updateTags(int postId, List<String> tags) async {
    await _tagRepository.updatePostTags(id: postId, tags: tags);
    await _postRepository.updatePost(
      field: Post.tagsConverter,
      postId: postId,
      data: tags.join(' '),
    );
  }

  Future<void> deletePost(
    String userId,
    int postId,
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
