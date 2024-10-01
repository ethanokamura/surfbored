import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surfbored/features/friends/cubit/friends_cubit.dart';
import 'package:surfbored/features/profile/profile.dart';
import 'package:user_repository/user_repository.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({required this.userId, super.key});
  final int userId;

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<UserRepository>().user.id!;
    return CustomContainer(
      child: Row(
        children: [
          // pfp && username
          UserDetails(id: userId),
          ActionButton(
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
