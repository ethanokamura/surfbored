import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:surfbored/features/boards/board/view/board_details.dart';
import 'package:surfbored/features/boards/board/view/board_posts.dart';
import 'package:surfbored/features/boards/boards.dart';
import 'package:surfbored/features/failures/board_failures.dart';
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
                              boardId: boardId,
                              onDelete: () async {
                                Navigator.pop(context);
                                await boardCubit.deleteBoard(boardId);
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
              body: buildBoardPage(
                context,
                board,
              ),
            );
          } else if (state.isDeleted) {
            return Center(
              child:
                  PrimaryText(text: AppLocalizations.of(context)!.fromDelete),
            );
          }
          return Center(
            child:
                PrimaryText(text: AppLocalizations.of(context)!.unknownFailure),
          );
        },
      ),
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
