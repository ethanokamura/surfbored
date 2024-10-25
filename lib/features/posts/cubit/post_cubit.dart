import 'package:app_core/app_core.dart';
import 'package:post_repository/post_repository.dart';
import 'package:tag_repository/tag_repository.dart';

// State definitions
part 'post_state.dart';

/// Manages the state and logic for post-related operations.
class PostCubit extends Cubit<PostState> {
  /// Creates a new instance of [PostCubit].
  /// Requires a [PostRepository] to handle data operations.
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

  bool get hasMorePosts => _hasMore;

  /// Fetches a specific post by its [postId].
  Future<void> fetchPost(int postId) async {
    emit(state.fromLoading());
    try {
      final post = await _postRepository.fetchPost(postId: postId);
      emit(state.fromPostLoaded(post));
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  /// Shuffles the posts for a given board
  /// Requires the board's [boardId]
  Future<void> shufflePostList(int boardId) async {
    emit(state.fromLoading());
    try {
      state.posts.shuffle();
      emit(state.fromPostsLoaded(state.posts));
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  /// Inserts a specific [field] with [data] for a given post
  /// Requires [postId] for the target post
  Future<void> editField(int postId, String field, dynamic data) async {
    emit(state.fromLoading());
    await _postRepository.updatePostField(
      postId: postId,
      field: field,
      data: data,
    );
    emit(state.fromUpdate());
  }

  /// Uploads the new post image.
  /// Requires the [postId] to update
  /// Requires the new [url] for the image
  Future<void> uploadImage(int postId, String url) async {
    emit(state.fromLoading());
    await _postRepository.updatePostField(
      postId: postId,
      field: Post.photoUrlConverter,
      data: url,
    );
    emit(state.fromSetImage(url));
  }

  /// Inserts post's new [data]
  /// Requires [postId] for the target post
  Future<void> updatePost(int postId, Map<String, dynamic> data) async {
    emit(state.fromLoading());
    final post = await _postRepository.updatePost(
      postId: postId,
      data: data,
    );
    emit(state.fromPostLoaded(post));
  }

  /// Updates the [tags] for a given post using its [postId]
  Future<void> updateTags(int postId, List<String> tags) async {
    await _tagRepository.updatePostTags(id: postId, tags: tags);
    await _postRepository.updatePostField(
      field: Post.tagsConverter,
      postId: postId,
      data: tags.join('+'),
    );
  }

  /// Deletes a given post using its [postId]
  /// TODO(Ethan): needs photoUrl? to clean supabase storage
  Future<void> deletePost(
    int postId,
  ) async {
    emit(state.fromLoading());
    try {
      await _postRepository.deletePost(postId: postId);
      emit(state.fromDeleted());
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  /// TODO(Ethan): remove
  Future<void> fetchAllPosts({bool refresh = false}) async {
    if (refresh == true) {
      _currentPage = 0;
      _hasMore = true;
      emit(state.fromEmpty());
    }

    if (!_hasMore) return;

    emit(state.fromLoading());
    try {
      final posts = await _postRepository.fetchAllPosts(
        offset: _currentPage * _pageSize,
        limit: _pageSize,
      );

      if (posts.isEmpty) {
        _hasMore = false; // No more posts to load
        emit(state.fromEmpty());
      } else {
        if (posts.length <= _pageSize) {
          _hasMore = false;
        } else {
          _currentPage++; // Increment the page number
        }
        emit(state.fromPostsLoaded([...state.posts, ...posts]));
      }
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  /// Fetches posts for a specific board.
  /// If [refresh] is true, resets pagination and fetches from the beginning.
  /// Implements pagination, fetching [_pageSize] posts at a time.
  Future<void> fetchBoardPosts(int boardId, {bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMore = true;
      emit(state.fromEmpty());
    }

    if (!_hasMore) return;

    emit(state.fromLoading());
    try {
      final posts = await _postRepository.fetchBoardPosts(
        boardId: boardId,
        offset: _currentPage * _pageSize,
        limit: _pageSize,
      );

      if (posts.isEmpty) {
        _hasMore = false; // No more boards to load
        emit(state.fromEmpty());
      } else {
        if (posts.length <= _pageSize) {
          _hasMore = false;
        } else {
          _currentPage++; // Increment the page number
        }
        emit(state.fromPostsLoaded([...state.posts, ...posts]));
      }
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }

  /// Fetches posts for a specific user.
  /// If [refresh] is true, resets pagination and fetches from the beginning.
  /// Implements pagination, fetching [_pageSize] posts at a time.
  Future<void> fetchUserPosts(String userId, {bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMore = true;
      emit(state.fromEmpty());
    }

    if (!_hasMore) return;

    emit(state.fromLoading());
    try {
      final posts = await _postRepository.fetchUserPosts(
        userId: userId,
        offset: _currentPage * _pageSize,
        limit: _pageSize,
      );

      if (posts.isEmpty) {
        _hasMore = false; // No more boards to load
        emit(state.fromEmpty());
      } else {
        if (posts.length <= _pageSize) {
          _hasMore = false;
        } else {
          _currentPage++; // Increment the page number
        }
        emit(state.fromPostsLoaded([...state.posts, ...posts]));
      }
    } on PostFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }
}
