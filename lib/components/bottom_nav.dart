// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/utils/theme/theme.dart';

// ui libraries
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  final List<BottomNavigationBarItem> _items = const <BottomNavigationBarItem>[
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
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: _items,
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
            Navigator.pushNamed(context, '/my_profile');
            break;
        }
      },
    );
  }
}
