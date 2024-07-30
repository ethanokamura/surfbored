import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rando/pages/profile/profile_settings/profile_settings.dart';
import 'package:user_repository/user_repository.dart';

class ProfileTopBar extends StatelessWidget {
  const ProfileTopBar({required this.user, super.key});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AutoSizeText(
            '@${user.username}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textDirection: TextDirection.ltr,
            // textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            ActionIconButton(
              inverted: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (context) => ProfileSettingsPage(userID: user.uid),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageWidget(
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
              user.name,
              style: TextStyle(
                color: Theme.of(context).textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  '${user.friends.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  'friends',
                  style: TextStyle(color: Theme.of(context).subtextColor),
                ),
              ],
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

class Friends extends StatelessWidget {
  const Friends({required this.friends, super.key});
  final List<String> friends;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      inverted: false,
      horizontal: null,
      vertical: null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // switch to rich text!
              Text(
                '${friends.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'Friends',
                style: TextStyle(color: Theme.of(context).subtextColor),
              ),
            ],
          ),
          // ActionIconButton(
          //   inverted: true,
          //   onTap: () {},
          //   icon: FontAwesomeIcons.plus,
          // ),
          ActionIconButton(
            inverted: true,
            onTap: () {},
            icon: FontAwesomeIcons.check,
          ),
        ],
      ),
    );
  }
}

class MyProfileButtons extends StatelessWidget {
  const MyProfileButtons({required this.userID, super.key});
  final String userID;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ActionButton(
            inverted: false,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<dynamic>(
                builder: (context) => ProfileSettingsPage(userID: userID),
              ),
            ),
            text: 'Edit',
          ),
        ),
        const HorizontalSpacer(),
        Expanded(
          child: ActionButton(
            inverted: false,
            onTap: () {},
            text: 'Share',
          ),
        ),
      ],
    );
  }
}

class DefaultProfileButtons extends StatelessWidget {
  const DefaultProfileButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          // add follow button
          child: ActionButton(
            inverted: false,
            onTap: () {},
            text: 'Add',
          ),
        ),
        const HorizontalSpacer(),
        Expanded(
          child: ActionButton(
            inverted: false,
            onTap: () {},
            text: 'Message',
          ),
        ),
      ],
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
            Icons.photo_library_outlined,
            size: 20,
          ),
        ),
        CustomTabWidget(
          child: Icon(
            Icons.list,
            size: 20,
          ),
        ),
      ],
    );
  }
}
