import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/app/cubit/app_cubit.dart';
import 'package:rando/pages/profile/edit_profile/edit_profile.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({required this.userID, super.key});
  final String userID;
  static MaterialPage<void> page({required String userID}) {
    return MaterialPage<void>(
      child: ProfileSettingsPage(userID: userID),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Settings')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<ThemeCubit, ThemeData>(
                  builder: (context, theme) {
                    final isDarkMode = theme.brightness == Brightness.dark;
                    return SwitchListTile(
                      title: const Text('Dark Mode'),
                      value: isDarkMode,
                      onChanged: (value) {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                    );
                  },
                ),
                ActionButton(
                  inverted: false,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (context) => EditProfilePage(userID: userID),
                    ),
                  ),
                  text: 'Edit Profile',
                ),
                ActionButton(
                  inverted: false,
                  onTap: context.read<AppCubit>().logOut,
                  text: 'Logout',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
