// dart packages
import 'package:flutter/material.dart';
import 'package:rando/components/images/image.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:rando/services/firestore.dart';
import 'package:rando/services/models.dart';

// components
import 'package:rando/components/items_list.dart';

// ui libraries
import 'package:rando/utils/theme/theme.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  // firestore service
  FirestoreService firestoreService = FirestoreService();
  var currentUser = AuthService().user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/user_settings'),
              icon: const Icon(Icons.settings))
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
                    ImageWidget(
                      imgURL: userData!.imgURL,
                      width: 128,
                      height: 128,
                    ),
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
                        "My Activities:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ItemListWidget(userID: currentUser!.uid),
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
