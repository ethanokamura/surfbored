import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surfbored/features/friends/cubit/friends_cubit.dart';
import 'package:surfbored/features/profile/profile.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({required this.userID, super.key});
  final String userID;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Row(
        children: [
          // pfp && username
          UserDetails(id: userID),
          ActionButton(
            text: 'Remove Friend',
            onTap: () => context.read<FriendsCubit>().modifiyFriend(userID),
          ),
        ],
      ),
    );
  }
}
