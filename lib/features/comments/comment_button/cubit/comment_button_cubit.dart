import 'package:app_core/app_core.dart';
import 'package:comment_repository/comment_repository.dart';

part 'comment_button_state.dart';

/// Manages the state and logic for comment count operations.
class CommentButtonCubit extends Cubit<CommentButtonState> {
  /// Creates a new instance of [CommentButtonCubit].
  /// Requires a [CommentRepository] to handle data operations.
  CommentButtonCubit(this._commentRepository)
      : super(const CommentButtonState.initial());

  final CommentRepository _commentRepository;

  /// Fetches the number of comments for a specifc post by its ID.
  Future<void> fetchData(int postId) async {
    emit(state.fromLoading());
    final comments =
        await _commentRepository.fetchTotalComments(postId: postId);
    emit(state.fromLoaded(comments));
  }
}
