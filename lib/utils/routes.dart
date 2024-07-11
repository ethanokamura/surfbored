// pages
import 'package:rando/pages/create/create_activity.dart';
import 'package:rando/pages/create/create_board.dart';
import 'package:rando/pages/create/select_create.dart';
import 'package:rando/pages/profile/create_profile.dart';
import 'package:rando/pages/profile/edit_profile.dart';
import 'package:rando/pages/login.dart';
import 'package:rando/pages/home.dart';
import 'package:rando/pages/profile/my_profile.dart';
import 'package:rando/pages/profile/user_settings.dart';
import 'package:rando/pages/router.dart';

var appRoutes = {
  '/': (context) => const RouterWidget(),
  '/home': (context) => const HomeScreen(),
  '/login': (context) => LoginScreen(),
  '/create': (context) => const SelectCreateScreen(),
  '/create-activity': (context) => const CreateActivityScreen(),
  '/create-board': (context) => const CreateBoardScreen(),
  '/my_profile': (context) => const MyProfileScreen(),
  '/user_settings': (context) => const UserSettingsScreen(),
  '/edit_profile': (context) => const EditProfileScreen(),
  '/create_profile': (context) => const CreateProfilePage(),
};
