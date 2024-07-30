import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/boards/cubit/board_cubit.dart';
import 'package:rando/pages/boards/edit_board/edit_board.dart';
import 'package:rando/pages/boards/shared/shared.dart';
import 'package:rando/pages/boards/shuffle/shuffle_posts.dart';
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
      top: false,
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
    final isOwner = context.read<BoardCubit>().isOwner(
          board.uid,
          user.uid,
        );
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
    final boardCubit = context.read<BoardCubit>();
    return Row(
      children: [
        if (isOwner)
          Expanded(
            child: ActionButton(
              inverted: false,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (context) {
                    return BlocProvider.value(
                      value: boardCubit,
                      child: EditBoardPage(boardID: board.id),
                    );
                  },
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
