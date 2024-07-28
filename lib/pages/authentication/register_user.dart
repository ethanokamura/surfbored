// dart packages
import 'package:app_ui/app_ui.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Username'),
      ),
      body: CustomPageView(
        child: Column(
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
                  if (isUnique) await UserRepository().createUser(newValue);
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
      ),
    );
  }
}
