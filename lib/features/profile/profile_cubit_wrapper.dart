import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/profile/cubit/profile_cubit.dart';
import 'package:user_repository/user_repository.dart';

class ProfileCubitWrapper extends StatelessWidget {
  const ProfileCubitWrapper({
    required this.defaultFunction,
    super.key,
  });

  final Widget Function(BuildContext, ProfileState) defaultFunction;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.hasError) {
          return Center(
            child: PrimaryText(text: context.l10n.fromGetUser),
          );
        }
        if (state.user.isEmpty) {
          return Center(
            child: PrimaryText(text: context.l10n.empty),
          );
        }
        return defaultFunction(context, state);
      },
    );
  }
}
