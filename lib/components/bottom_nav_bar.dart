// dart packages
import 'package:flutter/material.dart';
import 'package:rando/pages/create.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:rando/utils/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

// components
import 'package:rando/components/buttons/defualt_button.dart';

// pages
import 'package:rando/pages/profile/profile.dart';

// ui libraries
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
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
          "Create Something:",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textColor,
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            DefualtButton(
              icon: FontAwesomeIcons.mountain,
              text: "Activity",
              inverted: true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateScreen(type: 'items'),
                ),
              ),
            ),
            DefualtButton(
              icon: FontAwesomeIcons.list,
              text: "Board",
              inverted: true,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateScreen(type: 'boards'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (context.mounted) setState(() => selectedIndex = 0);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        if (context.mounted) setState(() => selectedIndex = index);
        if (index == 1) if (context.mounted) showCreateMenu();
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(userID: userID),
            ),
          );
          if (context.mounted) setState(() => selectedIndex = 0);
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
    );
  }
}
