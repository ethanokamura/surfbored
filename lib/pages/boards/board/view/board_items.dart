import 'package:boards_repository/boards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/activities/widgets/activity_card/activity_card.dart';
import 'package:rando/pages/boards/cubit/board_cubit.dart';
import 'package:user_repository/user_repository.dart';

class BoardItems extends StatelessWidget {
  const BoardItems({required this.boardID, super.key});
  final String boardID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoardCubit(
        boardsRepository: context.read<BoardsRepository>(),
        userRepository: context.read<UserRepository>(),
      )..streamBoardItems(boardID).listen((state) {
          context.read<BoardCubit>();
        }),
      child: BlocBuilder<BoardCubit, BoardState>(
        builder: (context, state) {
          if (state is BoardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BoardError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is BoardItemsLoaded) {
            final items = state.items;
            return GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final itemID = items[index];
                return ItemCard(itemID: itemID);
              },
            );
          } else {
            return const Text('No Lists Found. Check Database.');
          }
        },
      ),
    );
  }
}
