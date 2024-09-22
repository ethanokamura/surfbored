import 'package:app_core/app_core.dart';
import 'package:comment_repository/comment_repository.dart';
import 'package:post_repository/post_repository.dart';

part 'comment_button_state.dart';

class CommentButtonCubit extends Cubit<CommentButtonState> {
  CommentButtonCubit(this._postRepository)
      : super(const CommentButtonState.initial());

  final PostRepository _postRepository;

  Future<void> fetchData(String postID) async {
    emit(state.fromLoading());
    final comments = await _postRepository.fetchComments(postID);
    emit(state.fromLoaded(comments));
  }
}
