import 'package:app_ui/app_ui.dart';
import 'package:comment_repository/comment_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surfbored/features/comments/cubit/comments_cubit.dart';
import 'package:surfbored/features/comments/view/comments_list.dart';
import 'package:user_repository/user_repository.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({
    required this.postID,
    required this.userID,
    super.key,
  });
  final String postID;
  final String userID;
  static MaterialPage<void> page({
    required String postID,
    required String userID,
  }) {
    return MaterialPage<void>(
      child: CommentsPage(postID: postID, userID: userID),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomPageView(
        appBar: AppBar(
          title: const AppBarText(text: 'Comments'),
        ),
        top: true,
        body: BlocProvider<CommentsCubit>(
          create: (context) => CommentsCubit(
            commentRepository: context.read<CommentRepository>(),
          )..readComments(postID),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: CommentsView(postID: postID, userID: userID)),
              const VerticalSpacer(),
              CommentContorller(postID: postID, userID: userID),
              const VerticalSpacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentsView extends StatelessWidget {
  const CommentsView({
    required this.postID,
    required this.userID,
    super.key,
  });
  final String postID;
  final String userID;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsCubit, CommentsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.isLoaded) {
          final comments = state.comments;
          return CommentListView(comments: comments, postID: postID);
        } else if (state.isEmpty) {
          return const Center(
            child: PrimaryText(text: AppStrings.emptyComments),
          );
        }
        return const Center(
          child: PrimaryText(text: AppStrings.fetchFailure),
        );
      },
    );
  }
}

class CommentContorller extends StatefulWidget {
  const CommentContorller({
    required this.postID,
    required this.userID,
    super.key,
  });
  final String postID;
  final String userID;

  @override
  State<CommentContorller> createState() => _CommentContorllerState();
}

class _CommentContorllerState extends State<CommentContorller> {
  final textController = TextEditingController();
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CustomContainer(
            vertical: 0,
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Write a comment!',
              ),
            ),
          ),
        ),
        ActionIconButton(
          inverted: true,
          icon: AppIcons.message,
          onTap: () async {
            if (textController.text.trim().isNotEmpty) {
              await context.read<CommentsCubit>().createComment(
                    widget.postID,
                    widget.userID,
                    context.read<UserRepository>().user.id,
                    textController.text,
                  );
            }
            textController.clear();
          },
        ),
      ],
    );
  }
}
