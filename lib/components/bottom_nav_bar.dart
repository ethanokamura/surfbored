// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/utils/data/firestore/auth_service.dart';
import 'package:rando/utils/methods.dart';
import 'package:rando/utils/theme/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

// components
import 'package:rando/components/buttons/icon_button.dart';

// pages
import 'package:rando/pages/profile/profile.dart';
import 'package:rando/pages/create/create.dart';

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
    await showBottomModal(context, <Widget>[
      Text(
        "Create Something:",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 20),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomIconButton(
            icon: FontAwesomeIcons.mountain,
            label: "Activity",
            inverted: true,
            size: 40,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateScreen(type: 'items'),
                ),
              );
            },
          ),
          const SizedBox(width: 40),
          CustomIconButton(
            icon: FontAwesomeIcons.list,
            label: "Board",
            inverted: true,
            size: 40,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateScreen(type: 'boards'),
                ),
              );
            },
          ),
        ],
      ),
    ]);
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
