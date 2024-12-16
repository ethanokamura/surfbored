import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:comment_repository/comment_repository.dart';
import 'package:surfbored/features/comments/comment_button/cubit/comment_button_cubit.dart';
import 'package:surfbored/features/comments/comments_page/view/comments_page.dart';

class CommentButton extends StatelessWidget {
  const CommentButton({
    required this.comments,
    required this.postId,
    required this.postCreatorId,
    super.key,
  });
  final int postId;
  final int comments;
  final String postCreatorId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentButtonCubit(context.read<CommentRepository>())
        ..fetchData(postId),
      child: BlocBuilder<CommentButtonCubit, CommentButtonState>(
        builder: (context, state) {
          var totalComments = comments;
          if (state.isLoading) {
            // Show a loading indicator in the button if needed
          } else if (state.isLoaded) {
            totalComments = state.comments;
          }
          return ToggleButton(
            onTap: () => Navigator.push(
              context,
              bottomSlideTransition(
                CommentsPage(
                  postCreatorId: postCreatorId,
                  postId: postId,
                ),
              ),
            ),
            icon: defaultIconStyle(context, AppIcons.comment),
            text: totalComments.toString(),
          );
        },
      ),
    );
  }
}
