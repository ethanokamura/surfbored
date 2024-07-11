// pages
import 'package:rando/pages/create/create_item.dart';
import 'package:rando/pages/profile/create_profile.dart';
import 'package:rando/pages/profile/edit_profile.dart';
import 'package:rando/pages/login.dart';
import 'package:rando/pages/home.dart';
import 'package:rando/pages/router.dart';

var appRoutes = {
  '/': (context) => const RouterWidget(),
  '/home': (context) => HomeScreen(),
  '/login': (context) => LoginScreen(),
  '/post': (context) => const CreateItemScreen(),
  '/edit_profile': (context) => const EditProfileScreen(),
  '/create_profile': (context) => const CreateProfilePage(),
};
