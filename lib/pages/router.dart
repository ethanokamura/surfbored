// dart packages
import 'package:flutter/material.dart';
import 'package:rando/pages/main_screen.dart';

// utils
import 'package:rando/services/auth.dart';

// pages
import 'package:rando/pages/login.dart';

// show topics if logged in otherwise show log in page
class RouterWidget extends StatelessWidget {
  const RouterWidget({super.key});

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
          return const MainScreen();
        } else {
          // not logged in
          return LoginScreen();
        }
      },
    );
  }
}
