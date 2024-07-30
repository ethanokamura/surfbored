import 'package:bloc/bloc.dart';
import 'package:board_repository/board_repository.dart';
import 'package:equatable/equatable.dart';
part 'shuffle_posts_state.dart';

class ShufflePostsCubit extends Cubit<ShufflePostsState> {
  ShufflePostsCubit({
    required BoardRepository boardRepository,
  })  : _boardRepository = boardRepository,
        super(const ShufflePostsState.initial());

  final BoardRepository _boardRepository;

  int index = 0;

  Future<void> shufflePostList(String boardID) async {
    emit(state.fromBoardLoading());
    try {
      final posts = await _boardRepository.fetchPosts(boardID);
      if (posts.isEmpty) {
        emit(state.fromBoardEmpty());
        return;
      }
      posts.shuffle();
      emit(state.fromListLoaded(posts));
    } on BoardFailure catch (failure) {
      emit(state.fromBoardFailure(failure));
    }
  }

  void skipPost() {
    if (state.isLoaded) {
      final posts = state.posts;
      if (index + 1 < posts.length) {
        index++;
        emit(state.fromListLoaded(posts));
      }
    }
  }

  void incrementIndex() {
    final newIndex = state.index + 1;
    emit(state.copyWith(index: newIndex));
  }

  void decrementIndex() {
    final newIndex = state.index - 1;
    emit(state.copyWith(index: newIndex));
  }
}

extension _BoardStateExtensions on ShufflePostsState {
  ShufflePostsState fromBoardLoading() =>
      copyWith(status: ShufflePostsStatus.loading);

  ShufflePostsState fromBoardEmpty() =>
      copyWith(status: ShufflePostsStatus.empty);

  ShufflePostsState fromListLoaded(List<String> posts) => copyWith(
        status: ShufflePostsStatus.loaded,
        posts: posts,
        index: 0,
      );

  ShufflePostsState fromBoardFailure(BoardFailure failure) => copyWith(
        status: ShufflePostsStatus.failure,
        failure: failure,
      );
}
