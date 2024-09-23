import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surfbored/features/friends/cubit/friends_cubit.dart';
import 'package:surfbored/features/friends/friends_page/view/friends_list_view.dart';
import 'package:user_repository/user_repository.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({required this.userID, super.key});
  final String userID;
  static MaterialPage<void> page({required String userID}) {
    return MaterialPage<void>(
      child: FriendsPage(userID: userID),
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
        child: FriendsList(userID: userID),
      ),
    );
  }
}

class FriendsList extends StatelessWidget {
  const FriendsList({required this.userID, super.key});
  final String userID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FriendsCubit(context.read<UserRepository>())..streamFriends(userID),
      child: BlocBuilder<FriendsCubit, FriendsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            final friends = state.friends;
            return FriendsListView(
              friends: friends,
              hasMore: context.read<FriendsCubit>().hasMore(),
              onLoadMore: () async =>
                  context.read<FriendsCubit>().loadMoreFriends(userID),
              onRefresh: () async =>
                  context.read<FriendsCubit>().streamFriends(userID),
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
