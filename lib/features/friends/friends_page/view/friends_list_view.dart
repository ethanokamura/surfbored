import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:surfbored/features/friends/friends_page/view/friend_card.dart';

class FriendsListView extends StatelessWidget {
  const FriendsListView({
    required this.friends,
    required this.onLoadMore,
    required this.onRefresh,
    required this.hasMore,
    super.key,
  });
  final List<String> friends;
  final bool hasMore;
  final Future<void> Function() onLoadMore;
  final Future<void> Function() onRefresh;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.pixels - 25 >=
              scrollNotification.metrics.maxScrollExtent) {
            if (hasMore) onLoadMore();
          }
          return false;
        },
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: defaultPadding),
          separatorBuilder: (context, index) => const VerticalSpacer(),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            return FriendCard(userID: friend);
          },
        ),
      ),
    );
  }
}
