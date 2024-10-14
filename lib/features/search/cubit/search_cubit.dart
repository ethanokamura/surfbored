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

  int _currentPage = 0;
  final int _pageSize = 10;
  bool _hasMore = true;

  bool get hasMorePosts => _hasMore;

  void setQuery(String query) => emit(state.fromSetQuery(query));

  Future<void> searchForUsers({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMore = true;
      emit(state.fromEmpty());
    }
    if (!_hasMore) return;
    emit(state.fromLoading());
    try {
      final users = await _userRepository.searchUsers(
        query: state.query,
        offset: _currentPage * _pageSize,
        limit: _pageSize,
      );
      if (users.isEmpty || users.length < _pageSize) {
        _hasMore = false; // No more users to load
        emit(state.fromEmpty());
      } else {
        if (users.length <= _pageSize) {
          _hasMore = false;
        } else {
          _currentPage++; // Increment the page number
        }
        state.users.addAll(users);
        emit(state.fromUsersLoaded(state.users));
      }
    } on UserFailure catch (failure) {
      emit(state.fromUserFailure(failure));
    }
  }

  Future<void> searchForBoards(String query, {bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMore = true;
      emit(state.fromEmpty());
    }
    if (!_hasMore) return;
    emit(state.fromLoading());
    try {
      final boards = await _boardRepository.searchBoards(
        query: query,
        offset: _currentPage * _pageSize,
        limit: _pageSize,
      );
      if (boards.isEmpty || boards.length < _pageSize) {
        _hasMore = false; // No more boards to load
        emit(state.fromEmpty());
      } else {
        if (boards.length <= _pageSize) {
          _hasMore = false;
        } else {
          _currentPage++; // Increment the page number
        }
        state.boards.addAll(boards);
        emit(state.fromBoardsLoaded(state.boards));
      }
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }

  Future<void> searchForPosts(String query, {bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMore = true;
      emit(state.fromEmpty());
    }
    if (!_hasMore) return;
    emit(state.fromLoading());
    try {
      final posts = await _postRepository.searchPosts(
        query: query,
        offset: _currentPage * _pageSize,
        limit: _pageSize,
      );
      if (posts.isEmpty || posts.length < _pageSize) {
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
      emit(state.fromPostFailure(failure));
    }
  }
}
