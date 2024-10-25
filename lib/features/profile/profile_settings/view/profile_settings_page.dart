import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/app/cubit/app_cubit.dart';
import 'package:surfbored/features/profile/profile.dart';
import 'package:surfbored/theme/theme_cubit.dart';

class ProfileSettingsPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isDarkMode = context.read<ThemeCubit>().isDarkMode;
    return CustomPageView(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: AppStrings.settingsPage),
      ),
      top: false,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleText(
                  text: isDarkMode ? AppStrings.darkMode : AppStrings.lightMode,
                ),
                ToggleButton(
                  onSurface: false,
                  icon: defaultIconStyle(
                    context,
                    isDarkMode ? AppIcons.darkMode : AppIcons.lightMode,
                  ),
                  onTap: () => context.read<ThemeCubit>().toggleTheme(),
                ),
              ],
            ),
            const VerticalSpacer(),
            DefaultButton(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (context) {
                    return BlocProvider.value(
                      value: profileCubit,
                      child: const EditProfilePage(),
                    );
                  },
                ),
              ),
              text: AppStrings.editProfilePage,
            ),
            const VerticalSpacer(),
            ActionButton(
              onTap: context.read<AppCubit>().logOut,
              text: AppStrings.logOut,
            ),
          ],
        ),
      ),
    );
  }
}
