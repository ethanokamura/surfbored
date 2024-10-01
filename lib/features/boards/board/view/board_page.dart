import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surfbored/features/boards/boards.dart';
import 'package:surfbored/features/boards/saves/saves.dart';
import 'package:surfbored/features/posts/posts.dart';
import 'package:surfbored/features/profile/profile.dart';
import 'package:user_repository/user_repository.dart';

class BoardPage extends StatelessWidget {
  const BoardPage({required this.boardID, super.key});
  final String boardID;
  static MaterialPage<void> page({required String boardID}) {
    return MaterialPage<void>(
      child: BoardPage(boardID: boardID),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<BoardCubit>().fetchBoard(boardID);
    return BlocBuilder<BoardCubit, BoardState>(
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
                            boardID: board.id,
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
            child: PrimaryText(text: AppStrings.deletedBoard),
          );
        }
        return const Center(
          child: PrimaryText(text: AppStrings.fetchFailure),
        );
      },
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
            isOwner: board.userOwnsBoard(userID: user.id),
            user: user,
            board: board,
          ),
          const VerticalSpacer(),
          Flexible(child: PostsList(type: 'board', docID: board.id)),
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
              text: AppStrings.share,
            ),
          ),
        if (!isOwner)
          Expanded(
            child: SaveButton(
              board: board,
              userId: user.id,
            ),
          ),
        const HorizontalSpacer(),
        Expanded(
          child: ActionButton(
            inverted: false,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<dynamic>(
                builder: (context) => ShuffledPostsPage(boardID: board.id),
              ),
            ),
            text: AppStrings.shuffle,
          ),
        ),
      ],
    );
  }
}
