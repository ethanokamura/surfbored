import 'package:app_ui/app_ui.dart';
import 'package:boards_repository/boards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/activities/shared/activity_wrapper/activity_wrapper.dart';
import 'package:rando/pages/boards/cubit/board_cubit.dart';
import 'package:user_repository/user_repository.dart';

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
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.isLoaded) {
              return state.canIncrement || state.canDecrement
                  ? ShowItems(state: state)
                  : const ShowEndOfList();
            } else if (state.isFailure) {
              return const Center(child: Text('Failure Loading Board'));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }
}

class ShowItems extends StatelessWidget {
  const ShowItems({required this.state, super.key});
  final BoardState state;
  @override
  Widget build(BuildContext context) {
    final items = state.items;
    print('Current index: ${state.index}');
    print('Current item ID: ${items[state.index]}');
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ActivityWrapper(itemID: items[state.index]),
              const VerticalSpacer(),
              Row(
                children: [
                  Expanded(
                    child: ActionButton(
                      inverted: false,
                      text: 'Last',
                      onTap: () {
                        if (state.canDecrement) {
                          context.read<BoardCubit>().decrementIndex();
                        }
                      },
                    ),
                  ),
                  const HorizontalSpacer(),
                  Expanded(
                    child: ActionButton(
                      inverted: true,
                      text: 'Next',
                      onTap: () {
                        if (state.canIncrement) {
                          context.read<BoardCubit>().incrementIndex();
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ShowEndOfList extends StatelessWidget {
  const ShowEndOfList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
  }
}
