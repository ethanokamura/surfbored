// dart packages
import 'package:flutter/material.dart';
import 'package:rando/shared/widgets/buttons/defualt_button.dart';

// utils
import 'package:rando/core/services/auth_service.dart';

// ui
import 'package:provider/provider.dart';
import 'package:rando/core/providers/theme_provider.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});

  // logout user
  void logOut(BuildContext context) async {
    await AuthService.signOut();
    // reset navigation stack
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
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
                DefualtButton(
                  inverted: false,
                  onTap: () => Navigator.pushNamed(context, '/edit_profile'),
                  text: "Edit Profile",
                ),
                const SizedBox(height: 10),
                DefualtButton(
                  inverted: false,
                  onTap: () => logOut(context),
                  text: "Logout",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
