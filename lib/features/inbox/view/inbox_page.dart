import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:friend_repository/friend_repository.dart';
import 'package:surfbored/features/inbox/cubit/activity_cubit.dart';
import 'package:surfbored/features/profile/profile.dart';
import 'package:user_repository/user_repository.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});
  static MaterialPage<dynamic> page() =>
      const MaterialPage<void>(child: InboxPage());

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: AppBarStrings.inbox),
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
      )..fetchUserActivity(),
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
                final userId = requests[index];
                // create a user card with pfp and username!
                return UserDetails(id: userId);
              },
            );
          } else if (state.isEmpty) {
            return const Center(
              child: PrimaryText(text: DataStrings.empty),
            );
          }
          return const Center(
            child: PrimaryText(text: DataStrings.fromUnknownFailure),
          );
        },
      ),
    );
  }
}
