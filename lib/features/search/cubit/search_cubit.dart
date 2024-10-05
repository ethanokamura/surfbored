import 'package:app_core/app_core.dart';
import 'package:board_repository/board_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required BoardRepository boardRepository,
    required UserRepository userRepository,
    required PostRepository postRepository,
  })  : _boardRepository = boardRepository,
        _userRepository = userRepository,
        _postRepository = postRepository,
        super(const SearchState.initial());
  final BoardRepository _boardRepository;
  final UserRepository _userRepository;
  final PostRepository _postRepository;

  int currentPage = 0;
  final int pageSize = 10;
  bool hasMore = true;

  void setQuery(String query) => emit(state.fromSetQuery(query));

  Future<void> searchForUsers({bool refresh = false}) async {
    if (refresh) {
      currentPage = 0;
      hasMore = true;
      emit(state.fromEmpty());
    }
    if (!hasMore) return;
    emit(state.fromLoading());
    try {
      final users = await _userRepository.searchUsers(
        query: state.query,
        offset: currentPage * pageSize,
        limit: pageSize,
      );
      if (users.isEmpty) {
        hasMore = false; // No more boards to load
        emit(state.fromEmpty());
      } else {
        currentPage++; // Increment the page number
        state.users.addAll(users);
        emit(state.fromUsersLoaded(state.users));
      }
    } on UserFailure catch (failure) {
      emit(state.fromUserFailure(failure));
    }
  }

  Future<void> searchForBoards(String query, {bool refresh = false}) async {
    if (refresh) {
      currentPage = 0;
      hasMore = true;
      emit(state.fromEmpty());
    }
    if (!hasMore) return;
    emit(state.fromLoading());
    try {
      final boards = await _boardRepository.searchBoards(
        query: query,
        offset: currentPage * pageSize,
        limit: pageSize,
      );
      if (boards.isEmpty) {
        hasMore = false; // No more boards to load
        emit(state.fromEmpty());
      } else {
        currentPage++; // Increment the page number
        state.boards.addAll(boards);
        emit(state.fromBoardsLoaded(state.boards));
      }
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }

  Future<void> searchForPosts(String query, {bool refresh = false}) async {
    if (refresh) {
      currentPage = 0;
      hasMore = true;
      state.fromPostsLoaded([]); // clear posts
      emit(state.fromEmpty());
    }
    if (!hasMore) return;
    emit(state.fromLoading());
    try {
      final posts = await _postRepository.searchPosts(
        query: query,
        offset: currentPage * pageSize,
        limit: pageSize,
      );
      if (posts.isEmpty) {
        hasMore = false; // No more posts to load
        emit(state.fromEmpty());
      } else {
        currentPage++; // Increment the page number
        emit(state.fromPostsLoaded([...state.posts, ...posts]));
      }
    } on PostFailure catch (failure) {
      emit(state.fromPostFailure(failure));
    }
  }
}
