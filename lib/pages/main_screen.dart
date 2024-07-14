// dart packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:rando/utils/theme/theme.dart';

// pages
import 'package:rando/pages/create/select_create.dart';
import 'package:rando/pages/home.dart';
import 'package:rando/pages/profile/profile.dart';

// ui libraries
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  String userID = '';
  final List<Widget> pages = [];
  User user = AuthService().user!;

  @override
  void initState() {
    super.initState();
    getUserID();
  }

  void navigateBottomNavBar(int index) {
    setState(() => selectedIndex = index);
  }

  void getUserID() {
    setState(() => userID = user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [
          const HomeScreen(),
          SelectCreateScreen(),
          ProfileScreen(userID: userID),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: navigateBottomNavBar,
        selectedItemColor: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).colorScheme.surface,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.house,
              size: 20,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.plus,
              size: 20,
            ),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.user,
              size: 20,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
