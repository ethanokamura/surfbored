import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/friends/friend_button/cubit/friend_controller_cubit.dart';
import 'package:surfbored/features/friends/friends_page/view/friends_page.dart';

class FriendButton extends StatelessWidget {
  const FriendButton({
    required this.state,
    required this.isCurrent,
    required this.userId,
    super.key,
  });
  final FriendControllerState state;
  final bool isCurrent;
  final String userId;
  @override
  Widget build(BuildContext context) {
    final buttonText = _getButtonText(state);
    return ActionButton(
      onSurface: true,
      horizontal: defaultPadding,
      onTap: () => isCurrent
          ? Navigator.push(
              context,
              MaterialPageRoute<dynamic>(
                builder: (context) => FriendsPage(userId: userId),
              ),
            )
          : context.read<FriendControllerCubit>().friendStateSelection(userId),
      inverted: (!isCurrent && !state.isRequested) || !isCurrent,
      text: isCurrent ? AppStrings.myFriends : buttonText,
    );
  }

  String _getButtonText(FriendControllerState state) {
    if (state.isRequested) return AppStrings.friendRequestSent;
    if (state.isRecieved) return AppStrings.acceptFriendRequest;
    if (state.areFriends) return AppStrings.removeFriend;
    return AppStrings.addFriend;
  }
}
