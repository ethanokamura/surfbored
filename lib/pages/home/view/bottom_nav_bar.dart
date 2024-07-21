// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/core/services/auth_service.dart';

// pages
import 'package:rando/pages/profile/profile.dart';
import 'package:rando/pages/home/view/create_modal.dart';

// ui libraries
import 'package:rando/config/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  String userID = '';

  @override
  void initState() {
    super.initState();
    userID = AuthService().user!.uid;
  }

  void showCreateModal() async {
    await showCreateMenu(context);
    if (context.mounted) setState(() => _selectedIndex = 0);
  }

  void onTappedItem(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      showCreateModal();
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userID: userID),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      onTap: onTappedItem,
      selectedItemColor: Theme.of(context).accentColor,
      backgroundColor: Theme.of(context).colorScheme.surface,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.house, size: 20),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.plus, size: 20),
          label: 'Create',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.user, size: 20),
          label: 'Profile',
        ),
      ],
    );
  }
}
