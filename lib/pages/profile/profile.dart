// dart packages
import 'package:flutter/material.dart';
import 'package:rando/components/anon_wall.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:rando/services/models.dart';
import 'package:rando/services/firestore/user_service.dart';

// components
import 'package:rando/components/items_list.dart';
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
  var currentUser = AuthService().user;
  bool isCurrentUser = false;

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  Future<void> checkAuth() async {
    if (widget.userID == currentUser!.uid) {
      setState(() {
        isCurrentUser = true;
      });
    }
  }

  // logout user
  void logOut(BuildContext context) async {
    await AuthService().signOut();
    // reset navigation stack
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  // Stream to listen for changes in user data
  Stream<UserData> getUserDataStream() {
    return userService.getUserStream(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentUser!.isAnonymous
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
                      child: Text("ERROR: ${snapshot.error.toString()}"));
                } else if (snapshot.hasData) {
                  // has data
                  UserData userData = snapshot.data!;
                  return buildUserProfile(context, userData, isCurrentUser);
                } else {
                  // no data found
                  return const Center(child: Text("ERROR: USER NOT FOUND"));
                }
              },
            ),
    );
  }
}

buildUserProfile(BuildContext context, UserData userData, bool isCurrentUser) {
  double spacing = 15;
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '@${userData.username}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).accentColor,
            ),
          ),
          SizedBox(height: spacing),
          Row(
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
          SizedBox(height: spacing),
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
          SizedBox(height: spacing),
          isCurrentUser
              ? Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        inverted: false,
                        onTap: () =>
                            Navigator.pushNamed(context, '/user_settings'),
                        text: "Edit Profile",
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: CustomButton(
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
          const Text(
            "My Activities:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(child: ItemListWidget(userID: userData.id)),
        ],
      ),
    ),
  );
}

// Widget buildUserProfile(
//   BuildContext context,
//   UserData userData,
//   bool isCurrentUser,
// ) {
//   double spacing = 15;
//   return CustomScrollView(
//     slivers: [
//       SliverSafeArea(
//         sliver: SliverToBoxAdapter(
//           child: Padding(
//             padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   '@${userData.username}',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).accentColor,
//                   ),
//                 ),
//                 SizedBox(height: spacing),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           "${userData.following.length}",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           "following",
//                           style:
//                               TextStyle(color: Theme.of(context).subtextColor),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(width: 20),
//                     CircleImageWidget(
//                       imgURL: userData.imgURL,
//                       width: 96,
//                       height: 96,
//                     ),
//                     const SizedBox(width: 20),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "${userData.followers.length}",
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           "followers",
//                           style: TextStyle(
//                             color: Theme.of(context).subtextColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: spacing),
//                 userData.name != ''
//                     ? Text(
//                         userData.name,
//                         style: TextStyle(
//                           color: Theme.of(context).textColor,
//                         ),
//                       )
//                     : const SizedBox.shrink(),
//                 userData.website != ''
//                     ? Text(
//                         userData.website,
//                         style: TextStyle(
//                           color: Theme.of(context).accentColor,
//                         ),
//                       )
//                     : const SizedBox.shrink(),
//                 userData.bio != ''
//                     ? Text(
//                         userData.bio,
//                         style: TextStyle(
//                           color: Theme.of(context).subtextColor,
//                         ),
//                       )
//                     : const SizedBox.shrink(),
//                 SizedBox(height: spacing),
//                 isCurrentUser
//                     ? Row(
//                         children: [
//                           Expanded(
//                             child: CustomButton(
//                               inverted: false,
//                               onTap: () => Navigator.pushNamed(
//                                   context, '/user_settings'),
//                               text: "Edit Profile",
//                             ),
//                           ),
//                           const SizedBox(width: 20),
//                           Expanded(
//                             child: CustomButton(
//                               inverted: false,
//                               onTap: () => Navigator.pushNamed(
//                                   context, '/user_settings'),
//                               text: "Share Profile",
//                             ),
//                           ),
//                         ],
//                       )
//                     : Row(
//                         children: [
//                           Expanded(
//                             // add follow button
//                             child: ElevatedButton(
//                               onPressed: () {},
//                               child: const Text("Follow"),
//                             ),
//                           ),
//                           const SizedBox(width: 20),
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed: () {},
//                               child: const Text("Message"),
//                             ),
//                           ),
//                         ],
//                       ),
//                 SizedBox(height: spacing),
//                 const Text(
//                   "My Activities:",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       SliverPadding(
//         padding: const EdgeInsets.symmetric(horizontal: 25),
//         sliver: ItemListWidget(userID: userData.id),
//       ),
//     ],
//   );
// }
