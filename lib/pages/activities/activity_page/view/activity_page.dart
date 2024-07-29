// import 'package:app_ui/app_ui.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:rando/pages/activities/cubit/activity_cubit.dart';

import 'package:rando/pages/activities/shared/activity/activity.dart';
import 'package:user_repository/user_repository.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({required this.itemID, super.key});
  static MaterialPage<void> page({
    required String itemID,
  }) {
    return MaterialPage<void>(
      child: ActivityPage(itemID: itemID),
    );
  }

  final String itemID;

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Activity Screen'),
      ),
      body: BlocProvider(
        create: (context) => ItemCubit(
          itemsRepository: context.read<ItemsRepository>(),
          userRepository: context.read<UserRepository>(),
          // boardsRepository: context.read<BoardsRepository>(),
        )..streamItem(itemID),
        child: BlocBuilder<ItemCubit, ItemState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.isLoaded) {
              final item = state.item;
              return Center(
                child: Activity(item: item),
              );
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
