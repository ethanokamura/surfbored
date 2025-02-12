import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/images/images.dart';
import 'package:surfbored/features/profile/profile.dart';
import 'package:user_repository/user_repository.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({required this.id, super.key});
  final String id;

  Future<UserProfile> _fetchUserDetails(BuildContext context) async =>
      context.read<UserRepository>().readUserProfile(uuid: id);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        bottomSlideTransition(ProfilePage(userId: id)),
      ),
      child: Flexible(
        child: FutureBuilder<UserProfile>(
          future: _fetchUserDetails(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final profile = snapshot.data!;
              final username = profile.username;
              final photoUrl = profile.photoUrl;
              return Row(
                children: [
                  ImageWidget(
                    photoUrl: photoUrl,
                    width: 32,
                    aspectX: 1,
                    aspectY: 1,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  const SizedBox(width: 10),
                  CustomText(text: '@$username', style: userText),
                ],
              );
            }
            return CustomText(text: 'Unknown User', style: userText);
          },
        ),
      ),
    );
  }
}
