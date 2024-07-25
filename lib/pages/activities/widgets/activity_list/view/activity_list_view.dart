import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:rando/pages/activities/cubit/activity_cubit.dart';
import 'package:rando/pages/activities/widgets/activity_card/activity_card.dart';
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
      )..streamUserItems(userID),
      child: BlocBuilder<ItemCubit, ItemState>(
        builder: (context, state) {
          if (state is UserItemsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ItemError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is UserItemsLoaded) {
            final items = state.items;
            return ActivityListGrid(items: items);
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

class ActivityListGrid extends StatelessWidget {
  const ActivityListGrid({required this.items, super.key});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
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
  }
}
