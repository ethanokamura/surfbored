import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:rando/pages/activities/cubit/activity_cubit.dart';
import 'package:rando/pages/activities/shared/activity/activity.dart';
import 'package:user_repository/user_repository.dart';

class ActivityFeed extends StatelessWidget {
  const ActivityFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemCubit(
        itemsRepository: context.read<ItemsRepository>(),
        userRepository: context.read<UserRepository>(),
      )..streamAllItems(),
      child: BlocBuilder<ItemCubit, ItemState>(
        builder: (context, state) {
          if (state.status == ItemStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == ItemStatus.empty) {
            return const Center(child: Text('No items found.'));
          } else if (state.status == ItemStatus.failure) {
            return const Center(child: Text('Something went wrong.'));
          } else if (state.status == ItemStatus.loaded) {
            final items = state.items;
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              separatorBuilder: (context, index) => const VerticalSpacer(),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Activity(item: item);
              },
            );
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
