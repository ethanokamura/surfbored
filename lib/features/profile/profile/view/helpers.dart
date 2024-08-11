import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/features/profile/cubit/profile_cubit.dart';
import 'package:rando/features/profile/profile/cubit/friends_cubit.dart';
import 'package:rando/features/profile/profile_settings/profile_settings.dart';
import 'package:user_repository/user_repository.dart';

class ProfileTopBar extends StatelessWidget {
  const ProfileTopBar({
    required this.user,
    required this.profileCubit,
    required this.isCurrent,
    super.key,
  });
  final bool isCurrent;
  final User user;
  final ProfileCubit profileCubit;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          children: [
            ActionIconButton(
              inverted: false,
              padding: 10,
              onTap: () {},
              icon: FontAwesomeIcons.share,
            ),
            if (isCurrent)
              ActionIconButton(
                inverted: false,
                padding: 10,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (context) {
                        return BlocProvider.value(
                          value: profileCubit,
                          child: ProfileSettingsPage(
                            userID: user.uid,
                            profileCubit: profileCubit,
                          ),
                        );
                      },
                    ),
                  );
                },
                icon: FontAwesomeIcons.ellipsis,
              ),
            if (Navigator.of(context).canPop())
              ActionIconButton(
                inverted: false,
                padding: 10,
                onTap: () => Navigator.pop(context),
                icon: FontAwesomeIcons.xmark,
              ),
          ],
        ),
      ],
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.user, required this.isCurrent, super.key});
  final User user;
  final bool isCurrent;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SquareImage(
          photoURL: user.photoURL,
          width: 96,
          height: 96,
          borderRadius: defaultBorderRadius,
        ),
        const HorizontalSpacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserText(text: '@${user.username}', bold: true, fontSize: 24),
            TitleText(text: user.name),
            SecondaryText(
              text:
                  'joined: ${DateFormatter.formatTimestamp(user.memberSince!)}',
            ),
          ],
        ),
      ],
    );
  }
}

class About extends StatelessWidget {
  const About({required this.user, super.key});
  final User user;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      inverted: false,
      horizontal: null,
      vertical: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SecondaryText(text: 'about me'),
          PrimaryText(text: user.bio),
        ],
      ),
    );
  }
}

class Interests extends StatelessWidget {
  const Interests({super.key});

  @override
  Widget build(BuildContext context) {
    final interests = <String>[
      'tattoos',
      'dates',
      'outdoors',
      'food',
      'cats',
      'movies',
    ];
    return CustomContainer(
      inverted: false,
      horizontal: null,
      vertical: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SecondaryText(text: 'interests'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TagList(tags: interests),
          ),
        ],
      ),
    );
  }
}

class FriendsView extends StatelessWidget {
  const FriendsView({
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
    var buttonText = '';
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
            } else if (state.isRequested) {
              buttonText = 'Request Sent';
            } else if (state.isRecieved) {
              buttonText = 'Accept Request';
            } else if (state.areFriends) {
              buttonText = 'Remove Friend';
            } else {
              buttonText = 'Add Friend';
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    text: '${state.friends} ',
                    style: const TextStyle(
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
                ),
                if (!isCurrent)
                  SecondaryButton(
                    text: buttonText,
                    onTap: () async {
                      print('press');
                      await context
                          .read<FriendCubit>()
                          .friendStateSelection(userID);
                    },
                    inverted: !state.isRequested,
                  )
                else
                  // show friends list
                  SecondaryButton(
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
}

class ProfileTabBar extends StatelessWidget {
  const ProfileTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomTabBarWidget(
      tabs: [
        CustomTabWidget(
          child: Icon(
            FontAwesomeIcons.images,
            size: 15,
          ),
        ),
        CustomTabWidget(
          child: Icon(
            FontAwesomeIcons.list,
            size: 15,
          ),
        ),
        CustomTabWidget(
          child: Icon(
            FontAwesomeIcons.heart,
            size: 15,
          ),
        ),
      ],
    );
  }
}
