import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/features/boards/boards.dart';

class AddToBoardPage extends StatelessWidget {
  const AddToBoardPage({
    required this.userID,
    required this.postID,
    super.key,
  });
  final String userID;
  final String postID;
  static MaterialPage<void> page({
    required String postID,
    required String userID,
  }) {
    return MaterialPage<void>(
      child: AddToBoardPage(postID: postID, userID: userID),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: 'Add Activity To A Board'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.check_rounded),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: BlocProvider(
            create: (context) => BoardCubit(
              boardRepository: context.read<BoardRepository>(),
            )..streamUserBoards(userID),
            child: BlocBuilder<BoardCubit, BoardState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.isLoaded) {
                  final boards = state.boards;
                  return ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: boards.length,
                    itemBuilder: (context, index) {
                      final board = boards[index];
                      return SelectBoardCard(
                        postID: postID,
                        board: board,
                      );
                    },
                  );
                } else if (state.isFailure) {
                  return const Center(
                    child: PrimaryText(text: 'Failure Loading Board'),
                  );
                } else {
                  return const Center(
                    child: PrimaryText(text: 'Unknown state'),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
