// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:rando/utils/theme/theme.dart';

// ui
import 'package:provider/provider.dart';
import 'package:rando/utils/theme/theme_provider.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});

  // logout user
  void logOut(BuildContext context) async {
    await AuthService().signOut();
    // reset navigation stack
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Settings'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(themeProvider.isDarkMode
                        ? "Dark Mode:"
                        : "Light Mode:"),
                    Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (value) => themeProvider.toggleTheme(),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/edit_profile'),
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(
                      color: Theme.of(context).textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => logOut(context),
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      color: Theme.of(context).textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
