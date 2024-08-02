import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/features/boards/boards.dart';
import 'package:rando/features/posts/posts.dart';
import 'package:rando/features/profile/cubit/profile_cubit.dart';
import 'package:rando/features/profile/profile/view/helpers.dart';
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
      length: 3,
      child: CustomPageView(
        top: false,
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
                          ProfileTopBar(
                            user: user,
                            profileCubit: context.read<ProfileCubit>(),
                          ),
                          const VerticalSpacer(),
                          ProfileHeader(user: user, isCurrent: isCurrent),
                          const VerticalSpacer(),
                          About(user: user),
                          const VerticalSpacer(),
                          const Interests(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: user.uid.isNotEmpty
              ? Column(
                  children: [
                    const ProfileTabBar(),
                    const VerticalSpacer(),
                    Flexible(
                      child: TabBarView(
                        children: [
                          UserPostsList(userID: user.uid),
                          BoardsList(userID: user.uid),
                          UserLikedPostsList(userID: user.uid),
                        ],
                      ),
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
