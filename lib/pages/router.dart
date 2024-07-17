// dart packages
import 'package:flutter/material.dart';
import 'package:rando/pages/main_screen.dart';
import 'package:rando/pages/reroutes/error.dart';
import 'package:rando/pages/reroutes/loading.dart';

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
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          // show error widget
          return const ErrorScreen();
        } else if (snapshot.hasData) {
          // logged in
          return const MainScreen();
        } else {
          // not logged in
          return const LoginScreen();
        }
      },
    );
  }
}
