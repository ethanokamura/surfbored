import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/app/cubit/app_cubit.dart';
import 'package:surfbored/features/profile/profile.dart';
import 'package:surfbored/theme/theme_cubit.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({
    required this.profileCubit,
    super.key,
  });
  final ProfileCubit profileCubit;
  static MaterialPage<void> page({required ProfileCubit profileCubit}) {
    return MaterialPage<void>(
      child: ProfileSettingsPage(profileCubit: profileCubit),
    );
  }

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  late bool isDarkMode;
  @override
  void initState() {
    isDarkMode = context.read<ThemeCubit>().isDarkMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: context.l10n.settingsPage,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              icon: isDarkMode ? AppIcons.darkMode : AppIcons.lightMode,
              text: isDarkMode ? context.l10n.darkMode : context.l10n.lightMode,
              onTap: () async {
                await context.read<ThemeCubit>().toggleTheme();
                setState(() {
                  isDarkMode = context.read<ThemeCubit>().isDarkMode;
                });
              },
            ),
            const VerticalSpacer(),
            CustomButton(
              onTap: () => Navigator.push(
                context,
                bottomSlideTransition(
                  BlocProvider.value(
                    value: widget.profileCubit,
                    child: const EditProfilePage(),
                  ),
                ),
              ),
              text: context.l10n.editProfilePage,
            ),
            const VerticalSpacer(),
            CustomButton(
              color: 2,
              onTap: context.read<AppCubit>().logOut,
              text: context.l10n.logOut,
            ),
          ],
        ),
      ),
    );
  }
}
