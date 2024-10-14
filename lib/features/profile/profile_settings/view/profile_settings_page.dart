import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/app/cubit/app_cubit.dart';
import 'package:surfbored/features/profile/profile.dart';
import 'package:surfbored/theme/theme_cubit.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({
    required this.profileCubit,
    required this.userId,
    super.key,
  });
  final String userId;
  final ProfileCubit profileCubit;
  static MaterialPage<void> page({
    required String userId,
    required ProfileCubit profileCubit,
  }) {
    return MaterialPage<void>(
      child: ProfileSettingsPage(userId: userId, profileCubit: profileCubit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.read<ThemeCubit>().isDarkMode;
    return CustomPageView(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: UserStrings.settings),
      ),
      top: false,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ActionButton(
              text:
                  // ignore: lines_longer_than_80_chars
                  '${AppStrings.theme}: ${isDarkMode ? ButtonStrings.darkMode : ButtonStrings.lightMode}',
              onTap: () => context.read<ThemeCubit>().toggleTheme(),
            ),
            ActionButton(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (context) {
                    return BlocProvider.value(
                      value: profileCubit,
                      child: EditProfilePage(userId: userId),
                    );
                  },
                ),
              ),
              text: UserStrings.editProfile,
            ),
            ActionButton(
              onTap: context.read<AppCubit>().logOut,
              text: AuthStrings.logOut,
            ),
          ],
        ),
      ),
    );
  }
}
