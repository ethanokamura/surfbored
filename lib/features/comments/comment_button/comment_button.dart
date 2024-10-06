import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:comment_repository/comment_repository.dart';
import 'package:surfbored/features/comments/comment_button/cubit/comment_button_cubit.dart';
import 'package:surfbored/features/comments/view/comments_page.dart';

class CommentButton extends StatelessWidget {
  const CommentButton({
    required this.comments,
    required this.postId,
    super.key,
  });
  final int postId;
  final int comments;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CommentButtonCubit(context.read<CommentRepository>()),
      child: BlocBuilder<CommentButtonCubit, CommentButtonState>(
        builder: (context, state) {
          context.read<CommentButtonCubit>().fetchData(postId);
          var totalComments = comments;
          if (state.isLoading) {
            // Show a loading indicator in the button if needed
          } else if (state.isLoaded) {
            totalComments = state.comments;
          }
          return ToggleButton(
            onSurface: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<dynamic>(
                builder: (context) {
                  return CommentsPage(
                    postId: postId,
                  );
                },
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
