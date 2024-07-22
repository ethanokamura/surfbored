// pages
import 'package:rando/pages/authentication/register/register_user.dart';
import 'package:rando/pages/profile/view/edit_profile_page.dart';
import 'package:rando/pages/authentication/login/login.dart';
import 'package:rando/pages/home/view/home_page.dart';
import 'package:rando/pages/profile/view/profile_settings_page.dart';
import 'package:rando/pages/router.dart';

var appRoutes = {
  '/': (context) => const RouterWidget(),
  '/home': (context) => const HomePage(),
  '/login': (context) => const LoginScreen(),
  '/user_settings': (context) => const ProfileSettingsPage(),
  '/edit_profile': (context) => const EditProfilePage(),
  '/create_profile': (context) => const RegisterUserScreen(),
};
