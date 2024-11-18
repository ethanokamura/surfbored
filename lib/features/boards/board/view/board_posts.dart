import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/boards/board/view/board_buttons.dart';
import 'package:surfbored/features/failures/post_failures.dart';
import 'package:surfbored/features/posts/posts.dart';
import 'package:tag_repository/tag_repository.dart';
import 'package:user_repository/user_repository.dart';

class BoardPosts extends StatelessWidget {
  const BoardPosts({required this.board, required this.user, super.key});
  final Board board;
  final UserData user;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(
        postRepository: context.read<PostRepository>(),
        tagRepository: context.read<TagRepository>(),
      )..fetchBoardPosts(board.id!),
      child: listenForPostFailures<PostCubit, PostState>(
        failureSelector: (state) => state.failure,
        isFailureSelector: (state) => state.isFailure,
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.isLoaded) {
              final posts = state.posts;
              return Column(
                children: [
                  BoardButtons(
                    isOwner: board.userOwnsBoard(user.uuid),
                    user: user,
                    board: board,
                    posts: posts,
                    postCubit: context.read<PostCubit>(),
                  ),
                  const VerticalSpacer(),
                  Flexible(child: BoardPostList(boardId: board.id!)),
                ],
              );
            } else if (state.isEmpty) {
              return Center(
                child: PrimaryText(text: context.l10n.empty),
              );
            } else if (state.isDeleted || state.isUpdated) {
              context.read<PostCubit>().fetchBoardPosts(board.id!);
              return Center(
                child: PrimaryText(text: context.l10n.fromUpdate),
              );
            }
            return Center(
              child: PrimaryText(text: context.l10n.unknownFailure),
            );
          },
        ),
      ),
    );
  }
}
