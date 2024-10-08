import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/friends/friends.dart';
import 'package:surfbored/features/friends/friends_block/view/friend_button/friend_button.dart';
import 'package:surfbored/features/friends/friends_block/view/friend_count/friend_count.dart';

class FriendsBlock extends StatelessWidget {
  const FriendsBlock({
    required this.userId,
    required this.isCurrent,
    super.key,
  });
  final String userId;
  final bool isCurrent;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FriendsCountText(userId: userId),
          if (isCurrent)
            FriendsListButton(userId: userId)
          else
            FriendButton(userId: userId),
        ],
      ),
    );
  }
}

class FriendsListButton extends StatelessWidget {
  const FriendsListButton({required this.userId, super.key});
  final String userId;
  @override
  Widget build(BuildContext context) {
    return ActionButton(
      onSurface: true,
      horizontal: defaultPadding,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
          builder: (context) => FriendsPage(userId: userId),
        ),
      ),
      text: FriendStrings.myFriends,
    );
  }
}
