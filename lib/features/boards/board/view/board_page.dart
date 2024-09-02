import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/features/boards/boards.dart';
import 'package:rando/features/posts/posts.dart';
import 'package:rando/features/profile/profile.dart';
import 'package:user_repository/user_repository.dart';

class BoardPage extends StatelessWidget {
  const BoardPage({required this.boardID, super.key});
  final String boardID;
  static MaterialPage<void> page({required Board board}) {
    return MaterialPage<void>(
      child: BoardPageView(board: board),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<BoardCubit>().fetchBoard(boardID);
    return CustomPageView(
      top: false,
      body: BlocBuilder<BoardCubit, BoardState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            return BoardPageView(
              board: state.board,
            );
          } else if (state.isDeleted) {
            return const Center(
              child: PrimaryText(text: 'Board was deleted.'),
            );
          }
          return const Center(
            child: PrimaryText(text: 'Something went wrong'),
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
                      TopBar(title: board.title),
                      const VerticalSpacer(),
                      ImageWidget(
                        borderRadius: defaultBorderRadius,
                        photoURL: board.photoURL,
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
            isOwner: board.userOwnsBoard(userID: user.uid),
            user: user,
            board: board,
          ),
          const VerticalSpacer(),
          Flexible(
            child: PostsList(type: 'board', docID: board.id),
          ),
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({required this.title, super.key});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AppBarText(
            text: title,
            fontSize: 30,
            maxLines: 2,
          ),
        ),
        ActionIconButton(
          inverted: false,
          onTap: () => Navigator.pop(context),
          icon: FontAwesomeIcons.xmark,
        ),
      ],
    );
  }
}

class BoardDetails extends StatelessWidget {
  const BoardDetails({required this.board, super.key});
  final Board board;

  @override
  Widget build(BuildContext context) {
    final boardCubit = context.read<BoardCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: TitleText(
                text: board.title,
                fontSize: 24,
                maxLines: 2,
              ),
            ),
            ActionIconButton(
              inverted: false,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (context) {
                    return BlocProvider.value(
                      value: boardCubit,
                      child: EditBoardPage(
                        boardID: board.id,
                        onDelete: () async {
                          Navigator.pop(context);
                          await boardCubit.deleteBoard(
                            board.uid,
                            board.id,
                            board.photoURL,
                          );
                          if (context.mounted) Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
              icon: Icons.more_horiz,
            ),
          ],
        ),
        DescriptionText(text: board.description),
        const VerticalSpacer(),
        ProfileLink(uid: board.uid),
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
  final User user;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isOwner)
          Expanded(
            child: ActionButton(
              inverted: false,
              onTap: () {},
              text: 'Share',
            ),
          ),
        if (!isOwner)
          Expanded(
            child: ActionButton(
              inverted: false,
              onTap: () {},
              text: 'Save',
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
            text: 'Shuffle',
          ),
        ),
      ],
    );
  }
}
