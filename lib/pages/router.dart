// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/core/services/auth_service.dart';

// pages
import 'package:rando/pages/authentication/login/login.dart';
import 'package:rando/pages/home/view/home_page.dart';
import 'package:rando/pages/reroutes/error.dart';
import 'package:rando/pages/reroutes/loading.dart';

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
          return const HomePage();
        } else {
          // not logged in
          return const LoginScreen();
        }
      },
    );
  }
}
