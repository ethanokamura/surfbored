part of 'search_cubit.dart';

enum SearchStatus {
  initial,
  loading,
  loaded,
  searched,
  empty,
  failure,
}

final class SearchState extends Equatable {
  const SearchState._({
    this.query = '',
    this.users = const [],
    this.boards = const [],
    this.posts = const [],
    this.status = SearchStatus.initial,
    this.userFailure = UserFailure.empty,
    this.boardFailure = BoardFailure.empty,
    this.postFailure = PostFailure.empty,
  });

  // initial state
  const SearchState.initial() : this._();

  final String query;
  final List<UserProfile> users;
  final List<Post> posts;
  final List<Board> boards;
  final SearchStatus status;
  final UserFailure userFailure;
  final BoardFailure boardFailure;
  final PostFailure postFailure;

  // rebuilds the app when the props change
  @override
  List<Object?> get props => [
        query,
        users,
        posts,
        boards,
        status,
        userFailure,
        boardFailure,
        postFailure,
      ];

  SearchState copyWith({
    SearchStatus? status,
    String? query,
    List<UserProfile>? users,
    List<Post>? posts,
    List<Board>? boards,
    UserFailure? userFailure,
    PostFailure? postFailure,
    BoardFailure? boardFailure,
  }) {
    return SearchState._(
      query: query ?? this.query,
      users: users ?? this.users,
      posts: posts ?? this.posts,
      boards: boards ?? this.boards,
      status: status ?? this.status,
      userFailure: userFailure ?? this.userFailure,
      boardFailure: boardFailure ?? this.boardFailure,
      postFailure: postFailure ?? this.postFailure,
    );
  }
}

extension SearchStateExtensions on SearchState {
  bool get isLoaded => status == SearchStatus.loaded;
  bool get isLoading => status == SearchStatus.loading;
  bool get isFailure => status == SearchStatus.failure;
  bool get isEmpty => status == SearchStatus.empty;
  bool get isQueried => status == SearchStatus.searched;
}

extension _SearchStateExtensions on SearchState {
  SearchState fromLoading() => copyWith(status: SearchStatus.loading);
  SearchState fromEmpty() => copyWith(status: SearchStatus.empty);

  SearchState fromUserFailure(UserFailure failure) => copyWith(
        status: SearchStatus.failure,
        userFailure: failure,
      );
  SearchState fromUsersLoaded(List<UserProfile> users) => copyWith(
        status: SearchStatus.loaded,
        users: users,
      );
  SearchState fromBoardFailure(BoardFailure failure) => copyWith(
        status: SearchStatus.failure,
        boardFailure: failure,
      );
  SearchState fromPostsLoaded(List<Post> posts) => copyWith(
        status: SearchStatus.loaded,
        posts: posts,
      );
  SearchState fromPostFailure(PostFailure failure) => copyWith(
        status: SearchStatus.failure,
        postFailure: failure,
      );
  SearchState fromBoardsLoaded(List<Board> boards) => copyWith(
        status: SearchStatus.loaded,
        boards: boards,
      );
  SearchState fromSetQuery(String query) => copyWith(
        query: query,
        status: SearchStatus.searched,
      );
}
