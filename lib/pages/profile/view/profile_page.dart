// dart packages
import 'package:flutter/material.dart';

// data
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/profile_bloc.dart';
import '../data/profile_event.dart';
import '../data/profile_state.dart';

// utils
import 'package:rando/config/global.dart';
import 'package:rando/core/services/auth_service.dart';
import 'package:rando/core/models/models.dart';
import 'package:rando/core/services/user_service.dart';

// components
import 'package:rando/pages/profile/widgets/items_list.dart';
import 'package:rando/shared/widgets/buttons/defualt_button.dart';
import 'package:rando/shared/images/image.dart';
import 'package:rando/pages/profile/widgets/board_list.dart';
import 'package:rando/pages/profile/widgets/tab_bar/tab.dart';
import 'package:rando/pages/profile/widgets/tab_bar/tab_bar.dart';

// ui libraries
import 'package:rando/config/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ProfilePage extends StatelessWidget {
  final String userID;

  const ProfilePage({super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        UserService(),
        AuthService(),
      )..add(LoadProfile(userID)),
      child: Scaffold(
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileError) {
              return Center(child: Text("ERROR: ${state.error}"));
            } else if (state is ProfileLoaded) {
              return nestedUserProfile(
                  context, state.userData, state.isCurrentUser);
            }
            return const Center(child: Text("ERROR: USER NOT FOUND"));
          },
        ),
      ),
    );
  }
}

Widget nestedUserProfile(
  BuildContext context,
  UserData userData,
  bool isCurrentUser,
) {
  double spacing = 15;
  List<Widget> profileData(BuildContext context) {
    return [
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DefualtButton(
                horizontal: 0,
                vertical: 0,
                inverted: false,
                onTap: () => Navigator.pop(context),
                icon: CupertinoIcons.back,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: AutoSizeText(
                  '@${userData.username}',
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
              DefualtButton(
                horizontal: 0,
                vertical: 0,
                inverted: false,
                onTap: () => Navigator.pop(context),
                icon: CupertinoIcons.gear_alt_fill,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${userData.following.length}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "following",
                      style: TextStyle(color: Theme.of(context).subtextColor),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                ImageWidget(
                  imgURL: userData.imgURL,
                  width: 96,
                  height: 96,
                  borderRadius: borderRadius,
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${userData.followers.length}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "followers",
                      style: TextStyle(
                        color: Theme.of(context).subtextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: spacing),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              userData.name != ''
                  ? Text(
                      userData.name,
                      style: TextStyle(
                        color: Theme.of(context).textColor,
                      ),
                    )
                  : const SizedBox.shrink(),
              userData.website != ''
                  ? Text(
                      userData.website,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    )
                  : const SizedBox.shrink(),
              userData.bio != ''
                  ? Text(
                      userData.bio,
                      style: TextStyle(
                        color: Theme.of(context).subtextColor,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          SizedBox(height: spacing),
          isCurrentUser
              ? Row(
                  children: [
                    Expanded(
                      child: DefualtButton(
                        inverted: false,
                        onTap: () =>
                            Navigator.pushNamed(context, '/user_settings'),
                        text: "Edit Profile",
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DefualtButton(
                        inverted: false,
                        onTap: () =>
                            Navigator.pushNamed(context, '/user_settings'),
                        text: "Share Profile",
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      // add follow button
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Follow"),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Message"),
                      ),
                    ),
                  ],
                ),
          SizedBox(height: spacing),
        ],
      ),
    ];
  }

  return DefaultTabController(
    length: 2,
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            // These are the slivers that show up in the "outer" scroll view.
            return [
              SliverList(
                delegate: SliverChildListDelegate(profileData(context)),
              )
            ];
          },
          body: Column(
            children: [
              const CustomTabBarWidget(
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
              ),
              SizedBox(height: spacing),
              Expanded(
                child: TabBarView(
                  // These are the contents of the tab views, below the tabs.
                  children: [
                    ItemListWidget(userID: userData.uid),
                    BoardListWidget(userID: userData.uid),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
