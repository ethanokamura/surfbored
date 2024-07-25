import 'package:app_ui/app_ui.dart';
import 'package:boards_repository/boards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/boards/board/view/board_items.dart';
import 'package:rando/pages/boards/cubit/board_cubit.dart';
import 'package:rando/pages/boards/edit_board/edit_board.dart';
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
      )..streamBoard(boardID).listen((state) {
          context.read<BoardCubit>();
        }),
      child: Scaffold(
        body: BlocBuilder<BoardCubit, BoardState>(
          builder: (context, state) {
            if (state is BoardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BoardLoaded) {
              final board = state.board;
              final user = context.read<BoardCubit>().getUser();
              final isOwner = context.read<BoardCubit>().isOwner(
                    board.uid,
                    user.uid,
                  );
              final likedByUser = user.hasLikedBoard(boardID: board.id);
              return SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: defaultPadding,
                      right: defaultPadding,
                      bottom: defaultPadding,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
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
                                '${board.title}:',
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
                        ),
                        const VerticalSpacer(),
                        ImageWidget(
                          borderRadius: defaultBorderRadius,
                          photoURL: board.photoURL,
                          height: 256,
                          width: double.infinity,
                        ),
                        const VerticalSpacer(),
                        Text(
                          board.title,
                          style: TextStyle(
                            color: Theme.of(context).textColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          board.description,
                          style: TextStyle(
                            color: Theme.of(context).subtextColor,
                          ),
                        ),
                        Text(
                          '@${user.username}',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        const VerticalSpacer(),
                        Row(
                          children: [
                            if (isOwner)
                              Expanded(
                                child: ActionButton(
                                  inverted: false,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                      builder: (context) =>
                                          EditBoardPage(boardID: board.id),
                                    ),
                                  ),
                                  text: 'Edit Board',
                                ),
                              )
                            else
                              Expanded(
                                child: LikeButton(
                                  likes: board.likes,
                                  isLiked: likedByUser,
                                  onTap: () =>
                                      context.read<BoardCubit>().toggleLike(
                                            user.uid,
                                            board.id,
                                            likedByUser,
                                          ),
                                ),
                              ),
                            const HorizontalSpacer(),
                            Expanded(
                              child: ActionButton(
                                inverted: false,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (context) =>
                                        ShuffleItemScreen(boardID: board.id),
                                  ),
                                ),
                                text: 'Shuffle',
                              ),
                            ),
                          ],
                        ),
                        const VerticalSpacer(),
                        BoardItems(boardID: board.id),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is BoardError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }
}
