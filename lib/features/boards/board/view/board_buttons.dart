import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:post_repository/post_repository.dart';
// import 'package:surfbored/features/boards/board/view/saves/saves.dart';
import 'package:surfbored/features/posts/posts.dart';
import 'package:user_repository/user_repository.dart';

class BoardButtons extends StatelessWidget {
  const BoardButtons({
    required this.isOwner,
    required this.user,
    required this.board,
    required this.posts,
    required this.postCubit,
    super.key,
  });
  final bool isOwner;
  final Board board;
  final UserData user;
  final List<Post> posts;
  final PostCubit postCubit;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            onTap: () {},
            text: l10n.share,
          ),
        ),

        /// TODO(Ethan): add save
        // Expanded(
        //   child: SaveButton(
        //     board: board,
        //     userId: user.uuid,
        //   ),
        const HorizontalSpacer(),
        Expanded(
          child: CustomButton(
            color: 2,
            onTap: () {
              posts.shuffle();
              Navigator.push(
                context,
                bottomSlideTransition(
                  BlocProvider.value(
                    value: postCubit,
                    child: ShuffledPostsPage(posts: posts),
                  ),
                ),
              );
            },
            text: l10n.shuffle,
          ),
        ),
      ],
    );
  }
}
