// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:rando/utils/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

// components
import 'package:rando/components/buttons/icon_button.dart';

// pages
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
  User user = AuthService().user!;

  @override
  void initState() {
    super.initState();
    getUserID();
  }

  void getUserID() {
    setState(() => userID = user.uid);
  }

  Future<void> showCreateMenu() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          "Create Something!",
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
        content: Row(
          children: [
            CustomIconButton(
              icon: Icons.add,
              inverted: true,
              onTap: () {},
              label: "Activity",
            ),
            CustomIconButton(
              icon: Icons.add,
              inverted: true,
              onTap: () {},
              label: "Board",
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() => selectedIndex = index);
          if (selectedIndex == 1) Navigator.pushNamed(context, '/create');
          if (index == 2) showCreateMenu();
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(userID: userID),
              ),
            );
          }
        },
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
