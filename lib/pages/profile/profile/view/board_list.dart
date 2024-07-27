import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/boards/boards.dart';
import 'package:rando/pages/profile/profile/cubit/user_cubit.dart';
import 'package:user_repository/user_repository.dart';

class BoardsList extends StatelessWidget {
  const BoardsList({required this.userID, super.key});
  final String userID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(
        userRepository: context.read<UserRepository>(),
      )..streamBoards(userID),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            final boards = state.items;
            return BoardListView(boards: boards);
          } else if (state.isEmpty) {
            return const Center(child: Text('This board is empty.'));
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}

class BoardListView extends StatelessWidget {
  const BoardListView({required this.boards, super.key});
  final List<String> boards;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const VerticalSpacer(),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: boards.length,
      itemBuilder: (context, index) {
        final boardID = boards[index];
        return BoardCard(boardID: boardID);
      },
    );
  }
}
