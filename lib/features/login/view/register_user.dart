// dart packages
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser._();
  static Page<dynamic> page() => const MaterialPage<void>(
        key: ValueKey('register_page'),
        child: RegisterUser._(),
      );

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  String username = '';
  String name = '';
  String bio = '';
  String photoURL = '';
  @override
  Widget build(BuildContext context) {
    final uid = UserRepository().fetchCurrentUserID();
    print('user registration page');
    return CustomPageView(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: 'Create Username'),
      ),
      top: true,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EditSquareImage(
              width: 200,
              height: 200,
              photoURL: photoURL,
              collection: 'users',
              docID: uid,
              onFileChanged: (url) {
                photoURL = url;
              },
            ),
            const VerticalSpacer(),
            const PrimaryText(text: 'Upload a profile picture.'),
            const VerticalSpacer(),
            CustomInputField(
              label: 'Username*',
              text: username != '' ? username : 'username',
              onPressed: () async {
                final newValue = await editTextField(
                  context,
                  'Username',
                  30,
                  TextEditingController(),
                );
                if (newValue != null &&
                    newValue.trim() != '' &&
                    context.mounted) {
                  final isUnique =
                      await UserRepository().isUsernameUnique(newValue);
                  if (isUnique) {
                    setState(() => username = newValue);
                  }
                }
              },
            ),
            const VerticalSpacer(),
            CustomInputField(
              label: 'Name',
              text: name != '' ? name : 'Name',
              onPressed: () async {
                final newValue = await editTextField(
                  context,
                  'Name',
                  30,
                  TextEditingController(),
                );
                if (newValue != null &&
                    newValue.trim() != '' &&
                    context.mounted) {
                  setState(() => name = newValue);
                }
              },
            ),
            const VerticalSpacer(),
            CustomInputField(
              label: 'Bio',
              text: bio != '' ? bio : 'Bio',
              onPressed: () async {
                final newValue = await editTextField(
                  context,
                  'Bio',
                  150,
                  TextEditingController(),
                );
                if (newValue != null &&
                    newValue.trim() != '' &&
                    context.mounted) {
                  setState(() => bio = newValue);
                }
              },
            ),
            const VerticalSpacer(),
            const SecondaryText(text: '* required fields'),
            const VerticalSpacer(),
            if (username != '')
              ActionButton(
                inverted: true,
                onTap: () async {
                  final user = User(
                    uid: uid,
                    username: username,
                    name: name,
                    bio: bio,
                    photoURL: photoURL,
                  );
                  await UserRepository().createUser(uid, user);
                },
                text: 'Confirm',
              ),
          ],
        ),
      ),
    );
  }
}
