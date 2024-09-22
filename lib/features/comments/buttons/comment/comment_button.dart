import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/comments/buttons/comment/cubit/comment_button_cubit.dart';
import 'package:surfbored/features/comments/view/comments_page.dart';

class CommentButton extends StatelessWidget {
  const CommentButton({
    required this.comments,
    required this.postID,
    required this.userID,
    super.key,
  });
  final String postID;
  final String userID;
  final int comments;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentButtonCubit(context.read<PostRepository>()),
      child: BlocBuilder<CommentButtonCubit, CommentButtonState>(
        builder: (context, state) {
          context.read<CommentButtonCubit>().fetchData(postID);
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
                    postID: postID,
                    userID: userID,
                  );
                },
              ),
            ),
            icon: Icon(
              Icons.comment,
              color: Theme.of(context).textColor,
              size: 20,
            ),
            text: totalComments.toString(),
          );
        },
      ),
    );
  }
}
