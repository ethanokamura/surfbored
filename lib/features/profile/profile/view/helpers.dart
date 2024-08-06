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
    super.key,
  });
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
              onTap: () {},
              icon: FontAwesomeIcons.share,
            ),
            ActionIconButton(
              inverted: false,
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
            Text(
              '@${user.username}',
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user.name,
              style: TextStyle(
                color: Theme.of(context).textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'joined: ${DateFormatter.formatTimestamp(user.memberSince!)}',
              style: TextStyle(
                color: Theme.of(context).subtextColor,
                fontSize: 14,
              ),
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
          Text(
            'about me',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Theme.of(context).subtextColor,
            ),
          ),
          Text(
            user.bio,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Theme.of(context).textColor,
            ),
          ),
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
          Text(
            'interests',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Theme.of(context).subtextColor,
            ),
          ),
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
    return CustomContainer(
      inverted: false,
      horizontal: null,
      vertical: null,
      child: BlocProvider(
        create: (context) => FriendCubit(context.read<UserRepository>()),
        child: BlocBuilder<FriendCubit, FriendState>(
          builder: (context, state) {
            if (!state.isLoaded && !state.isLoading) {
              context.read<FriendCubit>().fetchData(userID);
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
                  // show add friend button
                  SecondaryButton(
                    inverted: state.areFriends,
                    text: state.areFriends
                        ? 'Remove Friend'
                        : state.senderID == null
                            ? 'Send request'
                            : state.senderID == userID
                                ? 'Add friend'
                                : 'Unsend request',
                    onTap: () {
                      if (state.areFriends || state.senderID == userID) {
                        context.read<FriendCubit>().toggleFriend(userID);
                      } else {
                        context.read<FriendCubit>().toggleFriendRequest(userID);
                      }
                    },
                    icon: state.areFriends
                        ? Icons.check
                        : state.senderID == null
                            ? Icons.add
                            : state.senderID == userID
                                ? Icons.add
                                : Icons.delete,
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
