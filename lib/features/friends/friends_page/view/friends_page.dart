import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:friend_repository/friend_repository.dart';
import 'package:surfbored/features/failures/friend_failures.dart';
import 'package:surfbored/features/friends/friends_page/cubit/friends_cubit.dart';
import 'package:surfbored/features/friends/friends_page/view/friends_list_view.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({required this.userId, super.key});
  final String userId;
  static MaterialPage<void> page({required String userId}) {
    return MaterialPage<void>(
      child: FriendsPage(userId: userId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: context.l10n.myFriends,
      body: Expanded(
        child: FriendsList(userId: userId),
      ),
    );
  }
}

class FriendsList extends StatelessWidget {
  const FriendsList({required this.userId, super.key});
  final String userId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FriendsCubit(context.read<FriendRepository>())..fetchFriends(userId),
      child: listenForFriendFailures<FriendsCubit, FriendsState>(
        failureSelector: (state) => state.failure,
        isFailureSelector: (state) => state.isFailure,
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
              return Center(
                child: CustomText(text: context.l10n.empty, style: primaryText),
              );
            }
            return Center(
              child: CustomText(
                text: context.l10n.unknownFailure,
                style: primaryText,
              ),
            );
          },
        ),
      ),
    );
  }
}
