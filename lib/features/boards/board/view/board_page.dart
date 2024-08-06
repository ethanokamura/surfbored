import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/features/boards/boards.dart';
import 'package:rando/features/posts/posts.dart';
import 'package:rando/features/profile/profile.dart';
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
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   title: AppBarText(text: board.title),
      // ),
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
    final user = context.read<UserRepository>().fetchCurrentUser();
    final isOwner = context.read<UserRepository>().isCurrentUser(board.uid);
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
                        boardID: board.id,
                        title: board.title,
                        description: board.description,
                        userID: board.uid,
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
        AppBarText(text: title, fontSize: 30),
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
  const BoardDetails({
    required this.title,
    required this.description,
    required this.userID,
    required this.boardID,
    super.key,
  });
  final String boardID;
  final String title;
  final String description;
  final String userID;

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
                text: title,
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
                      child: EditBoardPage(boardID: boardID),
                    );
                  },
                ),
              ),
              icon: Icons.more_horiz,
            ),
          ],
        ),
        DescriptionText(text: description),
        const VerticalSpacer(),
        ProfileLink(uid: userID),
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
