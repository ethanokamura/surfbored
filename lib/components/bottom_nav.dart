// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';

// ui libraries
import 'package:rando/utils/theme/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// pages
import 'package:rando/pages/profile/profile.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.listCheck,
            size: 20,
          ),
          label: 'Lists',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.plus,
            size: 20,
          ),
          label: 'Post',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesomeIcons.user,
            size: 20,
          ),
          label: 'Profile',
        ),
      ],
      fixedColor: Theme.of(context).accentColor,
      backgroundColor: Theme.of(context).colorScheme.surface,
      onTap: (int idx) {
        switch (idx) {
          case 0:
            // do nothing
            break;
          case 1:
            Navigator.pushNamed(context, '/post');
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(userID: AuthService().user!.uid),
              ),
            );
            break;
        }
      },
    );
  }
}
