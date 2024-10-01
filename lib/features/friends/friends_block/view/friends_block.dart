import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:friend_repository/friend_repository.dart';
import 'package:surfbored/features/friends/friend_button/cubit/friend_controller_cubit.dart';
import 'package:surfbored/features/friends/friend_button/view/friend_button.dart';
import 'package:surfbored/features/friends/friends_block/view/friend_count.dart';

class FriendsBlock extends StatelessWidget {
  const FriendsBlock({
    required this.userID,
    required this.isCurrent,
    super.key,
  });
  final String userID;
  final bool isCurrent;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: BlocProvider(
        create: (context) =>
            FriendControllerCubit(context.read<FriendRepository>())
              ..fetchData(userID),
        child: BlocBuilder<FriendControllerCubit, FriendControllerState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: PrimaryText(text: AppStrings.loadingFriends),
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FriendsCountText(friends: state.friends),
                FriendButton(
                  state: state,
                  isCurrent: isCurrent,
                  userID: userID,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
