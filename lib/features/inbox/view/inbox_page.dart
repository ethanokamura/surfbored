import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friend_repository/friend_repository.dart';
import 'package:surfbored/features/inbox/cubit/activity_cubit.dart';
import 'package:user_repository/user_repository.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});
  static Page<dynamic> page() => const MaterialPage<void>(child: InboxPage());

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: AppStrings.inbox),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            FriendRequestList(),
          ],
        ),
      ),
    );
  }
}

class FriendRequestList extends StatelessWidget {
  const FriendRequestList({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivityCubit(
        userRepository: context.read<UserRepository>(),
        friendRepository: context.read<FriendRepository>(),
      )..fetchFriendRequests(),
      child: BlocBuilder<ActivityCubit, ActivityState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            final requests = state.friendRequests;
            return ListView.separated(
              padding: const EdgeInsets.only(bottom: defaultPadding),
              separatorBuilder: (context, index) => const VerticalSpacer(),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final userID = requests[index];
                // create a user card with pfp and username!
                // return UserCard(userID: userID);
                return PrimaryText(text: userID); // placeholder
              },
            );
          } else if (state.isEmpty) {
            return const Center(
              child: PrimaryText(text: AppStrings.noFriendRequests),
            );
          } else {
            return const Center(
              child: PrimaryText(text: AppStrings.fetchFailure),
            );
          }
        },
      ),
    );
  }
}
