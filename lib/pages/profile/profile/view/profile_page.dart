import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/profile/cubit/profile_cubit.dart';
import 'package:rando/pages/profile/profile/view/activity_list_view.dart';
import 'package:rando/pages/profile/profile/view/board_list.dart';
import 'package:rando/pages/profile/profile/view/helpers.dart';
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
  final User user;

  @override
  Widget build(BuildContext context) {
    final isCurrent = context.read<UserRepository>().isCurrentUser(user.uid);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: CustomPageView(
          top: false,
          child: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[_buildProfileHeader(context, user, isCurrent)],
                  ),
                ),
              ];
            },
            body: user.uid.isNotEmpty
                ? _buildProfileContent(context, user.uid)
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}

Widget _buildProfileHeader(BuildContext context, User user, bool isCurrent) {
  return Padding(
    padding: const EdgeInsets.only(
      bottom: defaultPadding,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TopBar(user: user),
        const VerticalSpacer(),
        ProfileHeader(user: user, isCurrent: isCurrent),
        const VerticalSpacer(),
        About(bio: user.bio),
        const VerticalSpacer(),
        const Interests(),
        const VerticalSpacer(),
        Friends(friends: user.followers),
        const VerticalSpacer(),
        if (isCurrent)
          MyProfileButtons(userID: user.uid)
        else
          const DefaultProfileButtons(),
      ],
    ),
  );
}

Widget _buildProfileContent(BuildContext context, String userID) {
  return Column(
    children: [
      const ProfileTabBar(),
      const VerticalSpacer(),
      Expanded(
        child: TabBarView(
          children: [
            ActivityList(userID: userID),
            BoardsList(userID: userID),
          ],
        ),
      ),
    ],
  );
}
