// dart packages
import 'package:flutter/material.dart';
import 'package:rando/pages/create/select_create.dart';
import 'package:rando/pages/home.dart';
import 'package:rando/pages/profile/my_profile.dart';

// utils
import 'package:rando/utils/theme/theme.dart';

// ui libraries
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  final List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages.addAll({
      const HomeScreen(),
      const SelectCreateScreen(),
      const MyProfileScreen(),
    });
  }

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

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
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        currentIndex: currentIndex,
        selectedItemColor: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).colorScheme.surface,
        onTap: onItemTapped,
      ),
    );
  }
}
