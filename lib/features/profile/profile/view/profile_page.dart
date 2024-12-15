import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/boards/boards.dart';
import 'package:surfbored/features/images/images.dart';
import 'package:surfbored/features/posts/posts.dart';
import 'package:surfbored/features/profile/cubit/profile_cubit.dart';
import 'package:surfbored/features/profile/edit_profile/edit_profile.dart';
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
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.hasError) {
            return Center(
              child: PrimaryText(text: context.l10n.fromGetUser),
            );
          }
          if (state.user.isEmpty) {
            return Center(
              child: PrimaryText(text: context.l10n.empty),
            );
          }
          return ProfileBuilder(user: state.user);
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
      length: 2,
      child: CustomPageView(
        title: user.username,
        actions: [
          MoreProfileOptions(
            isCurrent: isCurrent,
            onEdit: () => Navigator.push(
              context,
              bottomSlideTransition(
                BlocProvider.value(
                  value: profileCubit,
                  child: ProfileSettingsPage(
                    profileCubit: profileCubit,
                  ),
                ),
              ),
            ),
            onBlock: () => {},
            // context.read<UserRepository>().toggleBlockUser(userId),
            onShare: () {},
          ),
        ],
        body: NestedWrapper(
          header: <Widget>[
            ProfileHeader(user: user),
            const VerticalSpacer(),
            if (user.bio.isNotEmpty) About(bio: user.bio),
            if (user.bio.isNotEmpty) const VerticalSpacer(),
            if (user.interests.isNotEmpty)
              InterestsList(interests: user.interests.split('+')),
            if (user.interests.isNotEmpty) const VerticalSpacer(),
            ProfileButtons(
              isCurrent: isCurrent,
              profileCubit: profileCubit,
            ),
          ],
          body: <Widget>[
            const ProfileTabBar(),
            const VerticalSpacer(),
            Flexible(
              child: TabBarView(
                children: [
                  UserPostList(userId: userId),
                  UserBoards(userId: userId),
                ],
              ),
            ),
          ],
        ),
      ),
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
            UserText(
              text: '@${user.username}',
              bold: true,
              fontSize: 24,
            ),
            if (user.displayName.isNotEmpty) TitleText(text: user.displayName),
            if (user.websiteUrl.isNotEmpty) WebLink(url: user.websiteUrl),
            SecondaryText(
              text: '${context.l10n.joined}: ${DateFormatter.formatTimestamp(
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
          SecondaryText(text: context.l10n.about),
          PrimaryText(text: bio),
        ],
      ),
    );
  }
}

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({
    required this.isCurrent,
    required this.profileCubit,
    super.key,
  });
  final bool isCurrent;
  final ProfileCubit profileCubit;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DefaultButton(
            onTap: () {},
            text: 'share',
          ),
        ),
        const HorizontalSpacer(),
        if (!isCurrent)
          Expanded(
            child: ActionButton(
              onTap: () {},
              text: 'subscribe',
            ),
          )
        else
          Expanded(
            child: ActionButton(
              onTap: () => Navigator.push(
                context,
                bottomSlideTransition(
                  BlocProvider.value(
                    value: profileCubit,
                    child: const EditProfilePage(),
                  ),
                ),
              ),
              text: 'edit profile',
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
    return CustomTabBarWidget(
      tabs: [
        CustomTabWidget(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              defaultIconStyle(context, AppIcons.posts),
              const HorizontalSpacer(),
              PrimaryText(text: context.l10n.posts),
            ],
          ),
        ),
        CustomTabWidget(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              defaultIconStyle(context, AppIcons.boards),
              const HorizontalSpacer(),
              PrimaryText(text: context.l10n.boards),
            ],
          ),
        ),
      ],
    );
  }
}
