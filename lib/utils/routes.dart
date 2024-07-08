// pages
import 'package:rando/pages/post.dart';
import 'package:rando/pages/profile/create_profile.dart';
import 'package:rando/pages/profile/edit_profile.dart';
import 'package:rando/pages/login.dart';
import 'package:rando/pages/home.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => LoginScreen(),
  '/post': (context) => PostScreen(),
  '/edit_profile': (context) => const EditProfileScreen(),
  '/create_profile': (context) => const CreateProfilePage(),
};
