import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friend_repository/friend_repository.dart';
import 'package:surfbored/features/friends/cubit/friends_cubit.dart';
import 'package:surfbored/features/friends/friends_page/view/friends_list_view.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({required this.userId, super.key});
  final int userId;
  static MaterialPage<void> page({required int userId}) {
    return MaterialPage<void>(
      child: FriendsPage(userId: userId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      appBar: AppBar(
        title: const AppBarText(text: 'Friends'),
        backgroundColor: Colors.transparent,
      ),
      body: Expanded(
        child: FriendsList(userId: userId),
      ),
    );
  }
}

class FriendsList extends StatelessWidget {
  const FriendsList({required this.userId, super.key});
  final int userId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FriendsCubit(context.read<FriendRepository>())..fetchFriends(userId),
      child: BlocBuilder<FriendsCubit, FriendsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            final friends = state.friends;
            return FriendsListView(
              friends: friends,
              onLoadMore: () async => context
                  .read<FriendsCubit>()
                  .fetchFriends(userId, refresh: true),
              onRefresh: () async =>
                  context.read<FriendsCubit>().fetchFriends(userId),
            );
          } else if (state.isEmpty) {
            return const Center(
              child: PrimaryText(text: AppStrings.emptyFriends),
            );
          }
          return const Center(
            child: PrimaryText(text: AppStrings.fetchFailure),
          );
        },
      ),
    );
  }
}
