// pages
import 'package:rando/pages/create.dart';
import 'package:rando/pages/create_redirect.dart';
import 'package:rando/pages/profile/create_profile.dart';
import 'package:rando/pages/profile/edit_profile.dart';
import 'package:rando/pages/login.dart';
import 'package:rando/pages/home.dart';
import 'package:rando/pages/profile/user_settings.dart';
import 'package:rando/pages/router.dart';

var appRoutes = {
  '/': (context) => const RouterWidget(),
  '/home': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/create': (context) => const CreateObjectScreen(),
  '/create_redirect': (context) => const CreateRedirect(),
  '/user_settings': (context) => const UserSettingsScreen(),
  '/edit_profile': (context) => const EditProfileScreen(),
  '/create_profile': (context) => const CreateProfilePage(),
};
