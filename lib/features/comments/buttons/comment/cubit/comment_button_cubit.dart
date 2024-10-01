import 'package:app_core/app_core.dart';
import 'package:comment_repository/comment_repository.dart';

part 'comment_button_state.dart';

class CommentButtonCubit extends Cubit<CommentButtonState> {
  CommentButtonCubit(this._commentRepository)
      : super(const CommentButtonState.initial());

  final CommentRepository _commentRepository;

  Future<void> fetchData(String postId) async {
    emit(state.fromLoading());
    final comments =
        await _commentRepository.fetchTotalComments(postId: postId);
    emit(state.fromLoaded(comments));
  }
}
