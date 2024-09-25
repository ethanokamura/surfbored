import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surfbored/features/boards/boards.dart';
import 'package:surfbored/features/friends/friends.dart';
import 'package:surfbored/features/posts/posts.dart';
import 'package:surfbored/features/profile/cubit/profile_cubit.dart';
import 'package:surfbored/features/profile/profile/view/interests.dart';
import 'package:surfbored/features/profile/profile_settings/profile_settings.dart';
import 'package:surfbored/features/unknown/unknown.dart';
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
          return user.isEmpty ? const UnkownPage() : ProfileBuilder(user: user);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ProfileBuilder extends StatelessWidget {
  const ProfileBuilder({required this.user, super.key});
  final User user;

  @override
  Widget build(BuildContext context) {
    final isCurrent = user.uid == context.read<UserRepository>().user.uid;
    final profileCubit = context.read<ProfileCubit>();
    return DefaultTabController(
      length: 3,
      child: CustomPageView(
        top: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: AppBarText(text: user.username),
          actions: [
            MoreProfileOptions(
              isCurrent: isCurrent,
              onEdit: () => Navigator.push(
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
              ),
              onBlock: () =>
                  context.read<UserRepository>().toggleBlockUser(user.uid),
              onShare: () {},
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: defaultPadding,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ProfileHeader(user: user, isCurrent: isCurrent),
                          const VerticalSpacer(),
                          if (user.bio.isNotEmpty) About(bio: user.bio),
                          if (user.bio.isNotEmpty) const VerticalSpacer(),
                          FriendsBlock(
                            userID: user.uid,
                            friends: user.friends,
                            isCurrent: isCurrent,
                          ),
                          const VerticalSpacer(),
                          if (user.tags.isNotEmpty)
                            InterestsList(interests: user.tags),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: Column(
            children: [
              const ProfileTabBar(),
              const VerticalSpacer(),
              Flexible(
                child: TabBarView(
                  children: [
                    PostsList(type: 'user', docID: user.uid),
                    UserBoardsList(userID: user.uid),
                    PostsList(type: 'likes', docID: user.uid),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
            MoreProfileOptions(
              isCurrent: isCurrent,
              onEdit: () => Navigator.push(
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
              ),
              onBlock: () =>
                  context.read<UserRepository>().toggleBlockUser(user.uid),
              onShare: () {},
            ),
            if (Navigator.of(context).canPop())
              ActionIconButton(
                inverted: false,
                onTap: () => Navigator.pop(context),
                icon: AppIcons.cancel,
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
            // UserText(text: '@${user.username}', bold: true, fontSize: 24),
            TitleText(text: user.name),
            WebLink(url: user.website),
            SecondaryText(
              text: '${AppStrings.joined}: ${DateFormatter.formatTimestamp(
                user.memberSince!,
              )}',
            ),
          ],
        ),
      ],
    );
  }
}

class About extends StatelessWidget {
  const About({required this.bio, super.key});
  final String bio;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SecondaryText(text: AppStrings.aboutMe),
          PrimaryText(text: bio),
        ],
      ),
    );
  }
}

class ProfileTabBar extends StatelessWidget {
  const ProfileTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTabBarWidget(
      tabs: [
        CustomTabWidget(
          child: defaultIconStyle(context, AppIcons.posts),
        ),
        CustomTabWidget(
          child: defaultIconStyle(context, AppIcons.boards),
        ),
        CustomTabWidget(
          child: defaultIconStyle(context, AppIcons.notLiked),
        ),
      ],
    );
  }
}
