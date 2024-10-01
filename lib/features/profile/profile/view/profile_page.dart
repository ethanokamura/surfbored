import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surfbored/features/boards/boards.dart';
import 'package:surfbored/features/friends/friends.dart';
import 'package:surfbored/features/posts/posts.dart';
import 'package:surfbored/features/profile/cubit/profile_cubit.dart';
import 'package:surfbored/features/profile/profile/view/interests.dart';
import 'package:surfbored/features/profile/profile_settings/profile_settings.dart';
import 'package:tag_repository/tag_repository.dart';
import 'package:user_repository/user_repository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    required this.userId,
    super.key,
  });

  static MaterialPage<void> page({required int userId}) {
    return MaterialPage<void>(
      child: ProfilePage(userId: userId),
    );
  }

  final int userId;

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
        tagRepository: context.read<TagRepository>(),
        userId: widget.userId,
      ),
      child: BlocBuilder<ProfileCubit, UserData>(
        builder: (context, user) {
          if (!user.isEmpty) return ProfileBuilder(user: user);
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ProfileBuilder extends StatelessWidget {
  const ProfileBuilder({required this.user, super.key});
  final UserData user;

  @override
  Widget build(BuildContext context) {
    final isCurrent = user.id == context.read<UserRepository>().user.id!;
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
                        userId: user.id!,
                        profileCubit: profileCubit,
                      ),
                    );
                  },
                ),
              ),
              onBlock: () => {},
              // context.read<UserRepository>().toggleBlockUser(user.id!),
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
                            userId: user.id!,
                            isCurrent: isCurrent,
                          ),
                          FutureBuilder(
                            future: context
                                .read<ProfileCubit>()
                                .fetchUserTags(user.id!),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const SizedBox.shrink();
                              }
                              final tags = snapshot.data;
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const VerticalSpacer(),
                                  InterestsList(interests: tags!),
                                ],
                              );
                            },
                          ),
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
                    PostsList(type: 'user', docID: user.id!),
                    UserBoardsList(userId: user.id!),
                    PostsList(type: 'likes', docID: user.id!),
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
  final UserData user;
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
                        userId: user.id!,
                        profileCubit: profileCubit,
                      ),
                    );
                  },
                ),
              ),
              onBlock: () => {},
              // context.read<UserRepository>().toggleBlockUser(user.id!),
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
  final UserData user;
  final bool isCurrent;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SquareImage(
          photoUrl: user.photoUrl,
          width: 96,
          height: 96,
          borderRadius: defaultBorderRadius,
        ),
        const HorizontalSpacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // UserText(text: '@${user.username}', bold: true, fontSize: 24),
            TitleText(text: user.displayName),
            WebLink(url: user.websiteUrl),
            SecondaryText(
              text: '${AppStrings.joined}: ${DateFormatter.formatTimestamp(
                user.createdAt!,
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
