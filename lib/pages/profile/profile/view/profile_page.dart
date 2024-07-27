import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/profile/cubit/profile_cubit.dart';
import 'package:rando/pages/profile/profile/view/activity_list_view.dart';
import 'package:rando/pages/profile/profile/view/board_list.dart';
import 'package:rando/pages/profile/profile_settings/profile_settings.dart';
import 'package:user_repository/user_repository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    required this.userID,
    super.key,
  });

  static MaterialPage<void> page({required String userID}) {
    return MaterialPage<void>(
      child: ProfilePage(userID: userID),
    );
  }

  final String userID;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) => ProfileCubit(
        userRepository: context.read<UserRepository>(),
        userID: widget.userID,
      ),
      child: BlocBuilder<ProfileCubit, User>(
        builder: (context, user) {
          return ProfileView(
            user: user,
            isCurrent: context.read<UserRepository>().isCurrentUser(user.uid),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ProfileView extends StatelessWidget {
  const ProfileView({required this.user, required this.isCurrent, super.key});
  final User user;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: NestedScrollView(
            headerSliverBuilder: (context, _) {
              // These are the slivers that show up in the "outer" scroll view.
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TopBar(username: user.username),
                          Padding(
                            padding: const EdgeInsets.all(defaultPadding),
                            child: UserDetails(user: user),
                          ),
                          if (isCurrent)
                            MyProfileButtons(userID: user.uid)
                          else
                            const DefaultProfileButtons(),
                        ],
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: user.uid.isNotEmpty
                ? Column(
                    children: [
                      const VerticalSpacer(),
                      const ProfileTabBar(),
                      const VerticalSpacer(),
                      Expanded(
                        child: TabBarView(
                          // These are the contents of the tab views, below the tabs.
                          children: [
                            ActivityList(userID: user.uid),
                            BoardsList(userID: user.uid),
                          ],
                        ),
                      ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({required this.username, super.key});
  final String username;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ActionButton(
          horizontal: 0,
          vertical: 0,
          inverted: false,
          onTap: () => Navigator.pop(context),
          icon: Icons.arrow_back_ios_new_sharp,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: AutoSizeText(
            '@$username',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 5),
        ActionButton(
          horizontal: 0,
          vertical: 0,
          inverted: false,
          onTap: () => Navigator.pop(context),
          icon: Icons.settings,
        ),
      ],
    );
  }
}

class UserDetails extends StatelessWidget {
  const UserDetails({required this.user, super.key});
  final User user;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: defaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${user.following.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'following',
                    style: TextStyle(color: Theme.of(context).subtextColor),
                  ),
                ],
              ),
              const HorizontalSpacer(),
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
                    '${user.followers.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'followers',
                    style: TextStyle(
                      color: Theme.of(context).subtextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const VerticalSpacer(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (user.name.isNotEmpty)
              Text(
                user.name,
                style: TextStyle(
                  color: Theme.of(context).textColor,
                ),
              ),
            if (user.website.isNotEmpty)
              Text(
                user.website,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            if (user.bio.isNotEmpty)
              Text(
                user.bio,
                style: TextStyle(
                  color: Theme.of(context).subtextColor,
                ),
              ),
          ],
        ),
      ],
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
            text: 'Edit Profile',
          ),
        ),
        const HorizontalSpacer(),
        Expanded(
          child: ActionButton(
            inverted: false,
            onTap: () => Navigator.pushNamed(context, '/user_settings'),
            text: 'Share Profile',
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
            text: 'Follow',
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
