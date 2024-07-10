// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';

// pages
import 'package:rando/pages/login.dart';
import 'package:rando/pages/lists.dart';

// show list screen if logged in otherwise show sign in page
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // show loading widget
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // show error widget
          return const Center(child: Text('error'));
        } else if (snapshot.hasData) {
          // logged in
          final user = AuthService().user;
          if (user == null) return LoginScreen();
          return ListScreen(userID: user.uid);
        } else {
          // not logged in
          return LoginScreen();
        }
      },
    );
  }
}
