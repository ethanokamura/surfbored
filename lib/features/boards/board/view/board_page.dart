import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/features/boards/cubit/board_cubit.dart';
import 'package:rando/features/boards/edit_board/edit_board.dart';
import 'package:rando/features/boards/shared/shared.dart';
import 'package:rando/features/boards/shuffle/shuffle_posts.dart';
import 'package:user_repository/user_repository.dart';

class BoardPage extends StatelessWidget {
  const BoardPage({required this.board, super.key});
  final Board board;
  static MaterialPage<void> page({required Board board}) {
    return MaterialPage<void>(
      child: BoardPageView(board: board),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: true,
      appBar: AppBar(
        title: Text(board.title),
      ),
      body: BoardPageView(board: board),
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
    context.read<BoardCubit>().fetchBoardPosts(board.id);
    final user = context.read<UserRepository>().fetchCurrentUser();
    final isOwner = context.read<UserRepository>().isCurrentUser(board.uid);
    return NestedScrollView(
      headerSliverBuilder: (context, _) {
        return [
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImageWidget(
                      borderRadius: defaultBorderRadius,
                      photoURL: board.photoURL,
                      width: double.infinity,
                    ),
                    const VerticalSpacer(),
                    BoardDetails(
                      boardID: board.id,
                      title: board.title,
                      description: board.description,
                      username: user.username,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ];
      },
      body: Column(
        children: [
          const VerticalSpacer(),
          BoardButtons(
            isOwner: isOwner,
            user: user,
            board: board,
          ),
          const VerticalSpacer(),
          Flexible(
            child: BoardPosts(boardID: board.id),
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
      children: [
        ActionIconButton(
          inverted: false,
          onTap: () => Navigator.pop(context),
          icon: Icons.arrow_back_ios_new_rounded,
        ),
        AutoSizeText(
          '$title:',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class BoardDetails extends StatelessWidget {
  const BoardDetails({
    required this.title,
    required this.description,
    required this.username,
    required this.boardID,
    super.key,
  });
  final String boardID;
  final String title;
  final String description;
  final String username;

  @override
  Widget build(BuildContext context) {
    final boardCubit = context.read<BoardCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            ActionIconButton(
              // horizontal: 0,
              // vertical: 0,
              inverted: false,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (context) {
                    return BlocProvider.value(
                      value: boardCubit,
                      child: EditBoardPage(boardID: boardID),
                    );
                  },
                ),
              ),
              icon: Icons.more_horiz,
            ),
          ],
        ),
        Text(
          description,
          style: TextStyle(
            color: Theme.of(context).subtextColor,
          ),
        ),
        Text(
          '@$username',
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
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
                builder: (context) => ShufflePostsPage(boardID: board.id),
              ),
            ),
            text: 'Shuffle',
          ),
        ),
      ],
    );
  }
}
