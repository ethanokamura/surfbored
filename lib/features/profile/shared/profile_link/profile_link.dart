import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/features/profile/profile.dart';
import 'package:user_repository/user_repository.dart';

class ProfileLink extends StatelessWidget {
  const ProfileLink({required this.uid, super.key});
  final String uid;

  Future<String?> _fetchUsername(BuildContext context) async {
    final userRepository = context.read<UserRepository>();
    return userRepository.fetchUsername(uid);
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
              builder: (context) => ProfilePage(userID: uid),
            ),
          ),
          child: Text(
            '@$username',
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
        );
      },
    );
  }
}
