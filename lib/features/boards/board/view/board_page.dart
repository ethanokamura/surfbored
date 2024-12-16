import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:surfbored/features/boards/board/view/board_details.dart';
import 'package:surfbored/features/boards/board/view/board_posts.dart';
import 'package:surfbored/features/boards/board_cubit_wrapper.dart';
import 'package:surfbored/features/boards/boards.dart';
import 'package:surfbored/features/images/images.dart';
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
    return BoardCubitWrapper(
      builder: (context, state) {
        if (state.isLoading) {
          return loadingBoardState(context);
        } else if (state.isLoaded) {
          final board = state.board;
          final boardCubit = context.read<BoardCubit>();
          return CustomPageView(
            title: board.title,
            actions: <Widget>[
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  bottomSlideTransition(
                    BlocProvider.value(
                      value: boardCubit,
                      child: EditBoardPage(
                        board: board,
                        onDelete: () async {
                          Navigator.pop(context);
                          await boardCubit.deleteBoard(boardId);
                          if (context.mounted) Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
                icon: defaultIconStyle(context, AppIcons.more),
              ),
            ],
            body: buildBoardPage(
              context,
              board,
            ),
          );
        } else if (state.isEmpty) {
          return emptyBoardState(context);
        } else if (state.isDeleted || state.isUpdated) {
          return updatedBoardState(context);
        }
        return errorBoardState(context);
      },
    );
  }
}

Widget buildBoardPage(BuildContext context, Board board) {
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
                      aspectX: 4,
                      aspectY: 3,
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
    body: BoardPosts(board: board, user: user),
  );
}
