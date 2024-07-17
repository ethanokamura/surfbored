// dart packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rando/components/anon_wall.dart';
import 'package:rando/components/lists/board_list.dart';
import 'package:rando/components/tab_bar/tab.dart';
import 'package:rando/components/tab_bar/tab_bar.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:rando/services/models.dart';
import 'package:rando/services/firestore/user_service.dart';

// components
import 'package:rando/components/lists/items_list.dart';
import 'package:rando/components/buttons/custom_button.dart';
import 'package:rando/components/images/circle_image.dart';
// import 'package:rando/components/images/image.dart';

// ui libraries
import 'package:rando/utils/theme/theme.dart';

class ProfileScreen extends StatefulWidget {
  final String userID;
  const ProfileScreen({super.key, required this.userID});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // firestore service
  UserService userService = UserService();
  User currentUser = AuthService().user!;
  bool isCurrentUser = false;
  String profileUsername = '';

  @override
  void initState() {
    super.initState();
    checkAuth();
    setUsername();
  }

  Future<void> checkAuth() async {
    if (widget.userID == currentUser.uid) {
      setState(() {
        isCurrentUser = true;
      });
    }
  }

  // logout user
  void logOut(BuildContext context) async {
    await AuthService().signOut();
    // reset navigation stack
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  Future<void> setUsername() async {
    String username = await userService.getUsername(widget.userID);
    setState(() => profileUsername = username);
  }

  // Stream to listen for changes in user data
  Stream<UserData> getUserDataStream() {
    return userService.getUserStream(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        title: Text(
          '@$profileUsername',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: currentUser.isAnonymous
          ? const AnonWallWidget(message: "Login To See Your Profile")
          : StreamBuilder<UserData>(
              stream: getUserDataStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // loading
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // error
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("ERROR: ${snapshot.error.toString()}"),
                        AnonWallWidget(
                          message:
                              "Error could not log in ${snapshot.error.toString()}",
                        )
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  // has data
                  UserData userData = snapshot.data!;
                  return nestedUserProfile(context, userData, isCurrentUser);
                } else {
                  // no data found
                  return const Center(child: Text("ERROR: USER NOT FOUND"));
                }
              },
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
            CircleImageWidget(
              imgURL: userData.imgURL,
              width: 96,
              height: 96,
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
                  child: CustomButton(
                    inverted: false,
                    onTap: () => Navigator.pushNamed(context, '/user_settings'),
                    text: "Edit Profile",
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomButton(
                    inverted: false,
                    onTap: () => Navigator.pushNamed(context, '/user_settings'),
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
