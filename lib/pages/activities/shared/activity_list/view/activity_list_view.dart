import 'package:boards_repository/boards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:rando/pages/activities/cubit/activity_cubit.dart';
import 'package:rando/pages/activities/shared/activity_grid/activity_grid.dart';
import 'package:user_repository/user_repository.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({required this.userID, super.key});
  final String userID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemCubit(
        itemsRepository: context.read<ItemsRepository>(),
        userRepository: context.read<UserRepository>(),
        boardsRepository: context.read<BoardsRepository>(),
      )..streamUserItems(userID),
      child: BlocBuilder<ItemCubit, ItemState>(
        builder: (context, state) {
          if (state is ItemsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ItemError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is ItemsLoaded) {
            final items = state.items;
            return ActivityGrid(items: items);
          } else {
            return const Text(
              'No Activities Found. Check Database.',
              textAlign: TextAlign.center,
            );
          }
        },
      ),
    );
  }
}
