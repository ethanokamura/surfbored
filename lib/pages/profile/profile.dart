// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:rando/services/firestore.dart';
import 'package:rando/services/models.dart';

// components
import 'package:rando/components/list.dart';
import 'package:rando/components/pfp.dart';
import 'package:rando/utils/default_image_config.dart';

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
  FirestoreService firestoreService = FirestoreService();
  var currentUser = AuthService().user;
  bool isCurrentUser = false;

  String getPhotoURL(String photoURL) {
    return (photoURL == '') ? DefaultImageConfig().profileIMG : photoURL;
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (isCurrentUser)
            IconButton(
              onPressed: () => logOut(context),
              icon: const Icon(Icons.logout),
            ),
        ],
      ),
      body: StreamBuilder<UserData>(
        stream: firestoreService.getUserStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // loading
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // error
            return Center(child: Text("ERROR: ${snapshot.error.toString()}"));
          } else if (snapshot.hasData) {
            // has data
            UserData? userData = snapshot.data;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProfilePicture(
                        profilePicturePath:
                            getPhotoURL(userData!.profilePicturePath)),
                    const SizedBox(width: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "@${userData.username}",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        if (isCurrentUser)
                          ElevatedButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/edit_profile'),
                            child: const Icon(Icons.edit),
                          ),
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("999 followers"),
                        SizedBox(width: 20),
                        Text("999 following"),
                      ],
                    ),
                    Text(
                      userData.bio,
                      style: TextStyle(
                        color: Theme.of(context).subtextColor,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "My Lists:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: MyList(userID: currentUser!.uid),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // no data found
            return const Center(child: Text("ERROR: USER NOT FOUND"));
          }
        },
      ),
    );
  }
}
