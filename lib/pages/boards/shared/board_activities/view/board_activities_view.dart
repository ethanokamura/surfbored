import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/activities/activities.dart';

class BoardActivities extends StatelessWidget {
  const BoardActivities({required this.boardID, super.key});
  final String boardID;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemCubit, ItemState>(
      builder: (context, state) {
        if (state is ItemsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ItemError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is ItemsLoaded) {
          final items = state.items;
          return ActivityGrid(items: items);
        } else {
          return const Text('No Lists Found. Check Database.');
        }
      },
    );
  }
}
