// dart packages
import 'package:app_ui/app_ui.dart';
import 'package:boards_repository/boards_repository.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class RegisterUser extends StatelessWidget {
  const RegisterUser._();
  static Page<dynamic> page() => const MaterialPage<void>(
        key: ValueKey('register_page'),
        child: RegisterUser._(),
      );

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Create Username'),
      ),
      top: true,
      body: Column(
        children: [
          CustomTextBox(
            text: 'username',
            label: 'username',
            onPressed: () async {
              final newValue = await editTextField(
                context,
                'title',
                30,
                TextEditingController(),
              );
              if (newValue != null && context.mounted) {
                final isUnique =
                    await UserRepository().isUsernameUnique(newValue);
                if (isUnique) {
                  final userID = await UserRepository().createUser(newValue);
                  await BoardsRepository().createBoard(
                    Board(
                      uid: userID,
                      title: 'Liked Activities:',
                      description: 'A collection of activities you have liked!',
                    ),
                    userID,
                  );
                }
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ActionButton(
            inverted: true,
            onTap: () {},
            text: 'Confirm',
          ),
        ],
      ),
    );
  }
}
