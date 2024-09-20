import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surfbored/features/profile/friends/cubit/friends_cubit.dart';
import 'package:user_repository/user_repository.dart';

class FriendsBlock extends StatelessWidget {
  const FriendsBlock({
    required this.userID,
    required this.friends,
    required this.isCurrent,
    super.key,
  });
  final String userID;
  final bool isCurrent;
  final int friends;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      inverted: false,
      horizontal: null,
      vertical: null,
      child: BlocProvider(
        create: (context) =>
            FriendCubit(context.read<UserRepository>())..fetchData(userID),
        child: BlocBuilder<FriendCubit, FriendState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: PrimaryText(text: 'Loading friends'));
            }

            final buttonText = _getButtonText(state);

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FriendsCountText(friends: state.friends),
                if (!isCurrent)
                  ActionButton(
                    onSurface: true,
                    text: buttonText,
                    onTap: () => _handleAction(context, state, userID),
                    inverted: !state.isRequested,
                  )
                else
                  ActionButton(
                    onSurface: true,
                    onTap: () {},
                    inverted: false,
                    text: 'My friends',
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getButtonText(FriendState state) {
    if (state.isRequested) return 'Request Sent';
    if (state.isRecieved) return 'Accept Request';
    if (state.areFriends) return 'Remove Friend';
    return 'Add Friend';
  }

  Future<void> _handleAction(
    BuildContext context,
    FriendState state,
    String userID,
  ) async {
    await context.read<FriendCubit>().friendStateSelection(userID);
  }
}

class FriendsCountText extends StatelessWidget {
  const FriendsCountText({
    required this.friends,
    super.key,
  });
  final int friends;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '$friends ',
        style: TextStyle(
          color: Theme.of(context).textColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'friends',
            style: TextStyle(
              color: Theme.of(context).subtextColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
