import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/boards/boards.dart';
import 'package:surfbored/features/friends/friends.dart';
import 'package:surfbored/features/images/images.dart';
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

  static MaterialPage<void> page({required String userId}) {
    return MaterialPage<void>(
      child: ProfilePage(userId: userId),
    );
  }

  final String userId;

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
          if (user.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ProfileBuilder(user: user);
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
    final userId = user.uuid;
    final isCurrent = userId == context.read<UserRepository>().user.uuid;
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
                        userId: user.uuid,
                        profileCubit: profileCubit,
                      ),
                    );
                  },
                ),
              ),
              onBlock: () => {},
              // context.read<UserRepository>().toggleBlockUser(userId),
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
                          ProfileHeader(user: user),
                          const VerticalSpacer(),
                          if (user.bio.isNotEmpty) About(bio: user.bio),
                          if (user.bio.isNotEmpty) const VerticalSpacer(),
                          FriendsBlock(
                            userId: userId,
                            isCurrent: isCurrent,
                          ),
                          if (user.interests.isNotEmpty) const VerticalSpacer(),
                          if (user.interests.isNotEmpty)
                            InterestsList(interests: user.interests.split('+')),
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
                    UserPostList(userId: userId),
                    UserBoards(userId: userId),
                    UserBoards(userId: userId),
                    // UserLikesList(userId: userId),
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
                        userId: user.uuid,
                        profileCubit: profileCubit,
                      ),
                    );
                  },
                ),
              ),
              onBlock: () => {},
              // context.read<UserRepository>().toggleBlockUser(user.uuid),
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
  const ProfileHeader({required this.user, super.key});
  final UserData user;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ImageWidget(
          photoUrl: user.photoUrl,
          width: 96,
          aspectX: 1,
          aspectY: 1,
          borderRadius: defaultBorderRadius,
        ),
        const HorizontalSpacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user.displayName.isEmpty)
              TitleText(text: '@${user.username}')
            else
              TitleText(text: user.displayName),
            if (user.websiteUrl.isNotEmpty) WebLink(url: user.websiteUrl),
            SecondaryText(
              text: '${UserStrings.joined}: ${DateFormatter.formatTimestamp(
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
          const SecondaryText(text: UserStrings.about),
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
