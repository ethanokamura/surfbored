import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/features/profile/profile.dart';
import 'package:user_repository/user_repository.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({required this.uid, super.key});
  final String uid;

  Future<String?> _fetchUsername(BuildContext context) async {
    final userRepository = context.read<UserRepository>();
    return userRepository.fetchUsername(uid);
  }

  Future<String?> _fetchPhotoURL(BuildContext context) async {
    final userRepository = context.read<UserRepository>();
    return userRepository.fetchPhotoURL(uid);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
          builder: (context) => ProfilePage(userID: uid),
        ),
      ),
      child: Flexible(
        child: Row(
          children: [
            FutureBuilder<String?>(
              future: _fetchPhotoURL(context),
              builder: (context, snapshot) {
                final photoURL = snapshot.data;
                return SquareImage(
                  photoURL: photoURL,
                  width: 32,
                  height: 32,
                  borderRadius: BorderRadius.circular(100),
                );
              },
            ),
            const SizedBox(width: 10),
            FutureBuilder<String?>(
              future: _fetchUsername(context),
              builder: (context, snapshot) {
                final username = snapshot.data ?? 'Unknown User';
                return UserText(text: '@$username', bold: false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
