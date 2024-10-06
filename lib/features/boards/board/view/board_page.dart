import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:surfbored/features/boards/board/view/saves/saves.dart';
import 'package:surfbored/features/boards/boards.dart';
import 'package:surfbored/features/failures/board_failures.dart';
import 'package:surfbored/features/posts/posts.dart';
import 'package:surfbored/features/profile/profile.dart';
import 'package:user_repository/user_repository.dart';

class BoardPage extends StatelessWidget {
  const BoardPage({required this.boardId, super.key});
  final int boardId;
  static MaterialPage<void> page({required int boardId}) {
    return MaterialPage<void>(
      child: BoardPage(boardId: boardId),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<BoardCubit>().fetchBoard(boardId);
    return listenForBoardFailures<BoardCubit, BoardState>(
      failureSelector: (state) => state.failure,
      isFailureSelector: (state) => state.isFailure,
      child: BlocBuilder<BoardCubit, BoardState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            final board = state.board;
            final boardCubit = context.read<BoardCubit>();
            return CustomPageView(
              top: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: AppBarText(text: board.title),
                actions: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (context) {
                          return BlocProvider.value(
                            value: boardCubit,
                            child: EditBoardPage(
                              boardId: board.id,
                              onDelete: () async {
                                Navigator.pop(context);
                                await boardCubit.deleteBoard(board.id);
                                if (context.mounted) Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    icon: defaultIconStyle(context, AppIcons.more),
                  ),
                ],
              ),
              body: BoardPageView(
                board: board,
              ),
            );
          } else if (state.isDeleted) {
            return const Center(
              child: PrimaryText(text: BoardStrings.delete),
            );
          }
          return const Center(
            child: PrimaryText(text: BoardStrings.failure),
          );
        },
      ),
    );
  }
}

class BoardPageView extends StatelessWidget {
  const BoardPageView({
    required this.board,
    super.key,
  });
  final Board board;
  @override
  Widget build(BuildContext context) {
    final user = context.read<UserRepository>().user;
    return NestedScrollView(
      headerSliverBuilder: (context, _) {
        return [
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: defaultPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ImageWidget(
                        borderRadius: defaultBorderRadius,
                        photoUrl: board.photoUrl,
                        width: double.infinity,
                      ),
                      const VerticalSpacer(),
                      BoardDetails(
                        board: board,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ];
      },
      body: Column(
        children: [
          BoardButtons(
            isOwner: board.userOwnsBoard(user.uuid),
            user: user,
            board: board,
          ),
          const VerticalSpacer(),
          Flexible(child: BoardPostList(boardId: board.id)),
        ],
      ),
    );
  }
}

class BoardDetails extends StatelessWidget {
  const BoardDetails({required this.board, super.key});
  final Board board;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          text: board.title,
          fontSize: 24,
          maxLines: 2,
        ),
        DescriptionText(text: board.description),
        const VerticalSpacer(),
        ProfileLink(id: board.creatorId),
      ],
    );
  }
}

class BoardButtons extends StatelessWidget {
  const BoardButtons({
    required this.isOwner,
    required this.user,
    required this.board,
    super.key,
  });
  final bool isOwner;
  final Board board;
  final UserData user;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isOwner)
          Expanded(
            child: ActionButton(
              inverted: false,
              onTap: () {},
              text: ButtonStrings.share,
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
            inverted: false,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<dynamic>(
                builder: (context) => ShuffledPostsPage(boardId: board.id),
              ),
            ),
            text: ButtonStrings.shuffle,
          ),
        ),
      ],
    );
  }
}
