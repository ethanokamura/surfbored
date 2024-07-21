// dart packages
import 'package:flutter/material.dart';
import 'package:rando/config/strings.dart';
import 'package:rando/pages/home/view/bottom_nav_bar.dart';

// utils
import 'package:rando/core/services/auth_service.dart';

// components
import 'package:rando/shared/widgets/buttons/defualt_button.dart';

// pages
import 'package:rando/pages/profile/profile.dart';

// ui
import 'package:rando/config/theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomeBody(),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                      builder: (context) => ProfileScreen(
                        userID: AuthService().user!.uid,
                      ),
                    ),
                  ),
                  icon: Icons.person,
                ),
                Text(
                  AppStrings.appTitle,
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
                  borderRadius: Theme.of(context).borderRadius,
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
    );
  }
}
