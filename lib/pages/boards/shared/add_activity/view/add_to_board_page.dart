import 'package:app_ui/app_ui.dart';
import 'package:boards_repository/boards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/boards/cubit/board_cubit.dart';
import 'package:rando/pages/boards/shared/select_board/select_board.dart';
import 'package:user_repository/user_repository.dart';

class AddToBoardPage extends StatelessWidget {
  const AddToBoardPage({
    required this.userID,
    required this.itemID,
    super.key,
  });
  final String userID;
  final String itemID;
  static MaterialPage<void> page({
    required String itemID,
    required String userID,
  }) {
    return MaterialPage<void>(
      child: AddToBoardPage(itemID: itemID, userID: userID),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Add Activity To A Board'),
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
              boardsRepository: context.read<BoardsRepository>(),
              userRepository: context.read<UserRepository>(),
            )..streamUserBoards(userID),
            child: BlocBuilder<BoardCubit, BoardState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.isLoaded) {
                  final boards = state.items;
                  return ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: boards.length,
                    itemBuilder: (context, index) {
                      final boardID = boards[index];
                      return SelectBoardCard(
                        itemID: itemID,
                        boardID: boardID,
                      );
                    },
                  );
                } else if (state.isFailure) {
                  return const Center(child: Text('Failure Loading Board'));
                } else {
                  return const Center(child: Text('Unknown state'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
