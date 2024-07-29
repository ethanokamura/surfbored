import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:rando/pages/activities/cubit/activity_cubit.dart';
import 'package:rando/pages/activities/shared/activity/activity.dart';
import 'package:user_repository/user_repository.dart';

class ActivityWrapper extends StatelessWidget {
  const ActivityWrapper({
    required this.onRefresh,
    required this.itemID,
    super.key,
  });
  final String itemID;
  final void Function() onRefresh;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemCubit(
        itemsRepository: context.read<ItemsRepository>(),
        userRepository: context.read<UserRepository>(),
        // boardsRepository: context.read<BoardsRepository>(),
      )..streamItem(itemID),
      child: SafeArea(
        child: BlocBuilder<ItemCubit, ItemState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.isLoaded) {
              final item = state.item;
              return Activity(item: item);
            } else if (state.isEmpty) {
              return const Center(child: Text('This item is empty.'));
            } else {
              return const Center(child: Text('Something went wrong'));
            }
          },
        ),
      ),
    );
  }
}
