import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/friends/friends_page/cubit/friends_cubit.dart';
import 'package:surfbored/features/profile/profile.dart';
import 'package:user_repository/user_repository.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({required this.userId, super.key});
  final String userId;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<UserRepository>().user.uuid;
    return CustomContainer(
      child: Row(
        children: [
          // pfp && username
          UserDetails(id: userId),
          DefaultButton(
            text: context.read<FriendsCubit>().remove
                ? 'Remove Friend'
                : 'Add Friend',
            onTap: () =>
                context.read<FriendsCubit>().modifiyFriend(currentUser, userId),
          ),
        ],
      ),
    );
  }
}
