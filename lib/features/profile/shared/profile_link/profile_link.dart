import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surfbored/features/profile/profile.dart';
import 'package:user_repository/user_repository.dart';

class ProfileLink extends StatelessWidget {
  const ProfileLink({required this.id, super.key});
  final String id;

  Future<String?> _fetchUsername(BuildContext context) async {
    final profile =
        await context.read<UserRepository>().readUserProfile(uuid: id);
    return profile.username;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _fetchUsername(context),
      builder: (context, snapshot) {
        final username = snapshot.data ?? 'Unknown User';
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<dynamic>(
              builder: (context) => ProfilePage(userId: id),
            ),
          ),
          child: Flexible(child: UserText(text: '@$username', bold: false)),
        );
      },
    );
  }
}
