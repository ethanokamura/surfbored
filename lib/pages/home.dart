// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';

// components
import 'package:rando/components/buttons/defualt_button.dart';

// pages
import 'package:rando/pages/profile/profile.dart';
import 'package:rando/utils/global.dart';

// ui
import 'package:rando/utils/theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var user = AuthService().user!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DefualtButton(
                    inverted: false,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(userID: user.uid),
                      ),
                    ),
                    icon: Icons.person,
                  ),
                  Text(
                    "LocalsOnly",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  DefualtButton(
                    inverted: false,
                    onTap: () => Navigator.pushNamed(context, '/create'),
                    icon: Icons.add,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    image: DecorationImage(
                      image: AssetImage(Theme.of(context).defaultImagePath),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
