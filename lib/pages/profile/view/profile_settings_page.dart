import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/data/theme/theme_bloc.dart';
import 'package:rando/data/theme/theme_state.dart';
import 'package:rando/data/theme/theme_event.dart';
import '../data/profile_bloc.dart';
import '../data/profile_event.dart';
import 'package:rando/shared/widgets/buttons/defualt_button.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Settings')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, state) {
                    bool isDarkMode =
                        state.themeData.brightness == Brightness.dark;
                    return SwitchListTile(
                      title: const Text('Dark Mode'),
                      value: isDarkMode,
                      onChanged: (value) {
                        context.read<ThemeBloc>().add(ToggleTheme());
                      },
                    );
                  },
                ),
                DefualtButton(
                  inverted: false,
                  onTap: () {
                    Navigator.pushNamed(context, '/edit_profile');
                  },
                  text: 'Edit Profile',
                ),
                DefualtButton(
                  inverted: false,
                  onTap: () {
                    BlocProvider.of<ProfileBloc>(context).add(LogOut());
                  },
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
