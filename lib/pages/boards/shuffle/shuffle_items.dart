import 'package:app_ui/app_ui.dart';
import 'package:boards_repository/boards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/activities/shared/activity/activity.dart';
import 'package:rando/pages/boards/cubit/board_cubit.dart';
import 'package:user_repository/user_repository.dart'; // Adjust import according to your actual path

class ShuffleItemScreen extends StatelessWidget {
  const ShuffleItemScreen({required this.boardID, super.key});
  final String boardID;
  static MaterialPage<void> page({required String boardID}) {
    return MaterialPage<void>(
      child: ShuffleItemScreen(boardID: boardID),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BoardCubit(
        boardsRepository: context.read<BoardsRepository>(),
        userRepository: context.read<UserRepository>(),
      )..shuffleItemList(boardID),
      child: Scaffold(
        appBar: AppBar(title: const Text('Shuffle Items')),
        body: BlocBuilder<BoardCubit, BoardState>(
          builder: (context, state) {
            if (state is BoardLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(boardID),
                    const CircularProgressIndicator(),
                  ],
                ),
              );
            } else if (state is BoardItemsLoaded) {
              final items = state.items;
              final index = context.select((BoardCubit cubit) => cubit.index);
              return index < items.length
                  ? SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Activity(itemID: items[index]),
                              const VerticalSpacer(),
                              Row(
                                children: [
                                  Expanded(
                                    child: ActionButton(
                                      inverted: true,
                                      text: 'Select',
                                      onTap: () {
                                        // Handle selection logic here
                                      },
                                    ),
                                  ),
                                  const HorizontalSpacer(),
                                  Expanded(
                                    child: ActionButton(
                                      inverted: false,
                                      text: 'Skip',
                                      onTap: () {
                                        context.read<BoardCubit>().skipItem();
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('No more items!'),
                            const VerticalSpacer(),
                            ActionButton(
                              text: 'Return',
                              inverted: true,
                              onTap: () => Navigator.pop(context),
                            ),
                          ],
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
