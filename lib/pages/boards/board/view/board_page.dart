import 'package:app_ui/app_ui.dart';
import 'package:boards_repository/boards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/boards/cubit/board_cubit.dart';
import 'package:rando/pages/boards/edit_board/edit_board.dart';
import 'package:rando/pages/boards/shared/board_activities/board_activities.dart';
import 'package:rando/pages/boards/shuffle/shuffle_items.dart';
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
    return BlocProvider(
      create: (context) => BoardCubit(
        boardsRepository: context.read<BoardsRepository>(),
        userRepository: context.read<UserRepository>(),
      )..streamBoard(boardID),
      child: CustomPageView(
        top: false,
        body: BlocBuilder<BoardCubit, BoardState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.isLoaded) {
              final board = state.board;
              final user = context.read<BoardCubit>().getUser();
              return BoardPageView(board: board, user: user);
            } else if (state.isEmpty) {
              return const Center(child: Text('This board is empty.'));
            } else {
              return const Center(child: Text('Something went wrong'));
            }
          },
        ),
      ),
    );
  }
}

class BoardPageView extends StatelessWidget {
  const BoardPageView({
    required this.board,
    required this.user,
    super.key,
  });
  final Board board;
  final User user;
  @override
  Widget build(BuildContext context) {
    final isOwner = context.read<BoardCubit>().isOwner(
          board.uid,
          user.uid,
        );
    return BlocProvider(
      create: (context) => BoardCubit(
        userRepository: context.read<UserRepository>(),
        boardsRepository: context.read<BoardsRepository>(),
      )..fetchBoardItems(board.id),
      child: NestedScrollView(
        headerSliverBuilder: (context, _) {
          return [
            SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TopBar(title: board.title),
                      const VerticalSpacer(),
                      ImageWidget(
                        borderRadius: defaultBorderRadius,
                        photoURL: board.photoURL,
                        height: 256,
                        width: double.infinity,
                      ),
                      const VerticalSpacer(),
                      BoardDetails(
                        title: board.description,
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
              child: BoardActivities(boardID: board.id),
            ),
          ],
        ),
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
      children: [
        ActionButton(
          horizontal: 0,
          vertical: 0,
          inverted: false,
          onTap: () => Navigator.pop(context),
          icon: Icons.arrow_back_ios_new_rounded,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: AutoSizeText(
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
        ),
        const SizedBox(width: 5),
        ActionButton(
          horizontal: 0,
          vertical: 0,
          inverted: false,
          onTap: () {}, // settings
          icon: Icons.more_horiz,
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
    super.key,
  });
  final String title;
  final String description;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '@$username',
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
        Text(
          description,
          style: TextStyle(
            color: Theme.of(context).subtextColor,
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
        if (isOwner)
          Expanded(
            child: ActionButton(
              inverted: false,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (context) => EditBoardPage(boardID: board.id),
                ),
              ),
              text: 'Edit Board',
            ),
          )
        else
          Expanded(
            child: ActionButton(
              inverted: false,
              onTap: () {},
              text: 'Save Board',
            ),
          ),
        const HorizontalSpacer(),
        Expanded(
          child: ActionButton(
            inverted: false,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<dynamic>(
                builder: (context) => ShuffleItemScreen(boardID: board.id),
              ),
            ),
            text: 'Shuffle',
          ),
        ),
      ],
    );
  }
}
