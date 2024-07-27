import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/activities/shared/activity_grid/activity_grid.dart';
import 'package:rando/pages/profile/profile/cubit/user_cubit.dart';
import 'package:user_repository/user_repository.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({required this.userID, super.key});
  final String userID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(
        userRepository: context.read<UserRepository>(),
      )..streamItems(userID),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            final items = state.items;
            return ActivityGrid(items: items);
          } else if (state.isEmpty) {
            return const Center(child: Text('Item is empty.'));
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
