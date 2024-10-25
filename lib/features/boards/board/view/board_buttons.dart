import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/boards/board/view/saves/saves.dart';
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
    return Row(
      children: [
        if (isOwner)
          Expanded(
            child: ActionButton(
              onTap: () {},
              text: AppLocalizations.of(context)!.share,
            ),
          ),
        if (!isOwner)
          Expanded(
            child: SaveButton(
              board: board,
              userId: user.uuid,
            ),
          ),
        const HorizontalSpacer(),
        Expanded(
          child: ActionButton(
            onTap: () {
              posts.shuffle();
              Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (context) {
                    return BlocProvider.value(
                      value: postCubit,
                      child: ShuffledPostsPage(posts: posts),
                    );
                  },
                ),
              );
            },
            text: AppLocalizations.of(context)!.shuffle,
          ),
        ),
      ],
    );
  }
}
