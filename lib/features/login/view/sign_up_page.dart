// dart packages
import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:surfbored/app/cubit/app_cubit.dart';
import 'package:user_repository/user_repository.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage._();

  static Page<dynamic> page() => const MaterialPage<void>(
        key: ValueKey('sign_up_page'),
        child: SignUpPage._(),
      );

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String username = '';
  String name = '';
  String bio = '';
  String photoURL = '';
  @override
  Widget build(BuildContext context) {
    final uid = context.read<UserRepository>().user.uid;
    return CustomPageView(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: AppStrings.createUsername),
      ),
      top: true,
      body: SingleChildScrollView(
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
            const PrimaryText(text: AppStrings.uploadProfilePicture),
            const VerticalSpacer(),
            CustomInputField(
              label: '${AppStrings.username}*',
              text: username != '' ? username : AppStrings.username,
              onPressed: () async {
                final newValue = await editTextField(
                  context,
                  AppStrings.username,
                  TextEditingController(),
                );
                if (newValue != null &&
                    newValue.trim() != '' &&
                    context.mounted) {
                  final isUnique = await context
                      .read<UserRepository>()
                      .isUsernameUnique(newValue);
                  if (isUnique) {
                    setState(() => username = newValue);
                  }
                }
              },
            ),
            const VerticalSpacer(),
            CustomInputField(
              label: AppStrings.name,
              text: name != '' ? name : AppStrings.name,
              onPressed: () async {
                final newValue = await editTextField(
                  context,
                  AppStrings.name,
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
              label: AppStrings.bio,
              text: bio != '' ? bio : AppStrings.bio,
              onPressed: () async {
                final newValue = await editTextField(
                  context,
                  AppStrings.bio,
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
            const SecondaryText(text: AppStrings.requiredFields),
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
                  final newUser =
                      await context.read<UserRepository>().createUser(user);
                  if (context.mounted) {
                    context.read<AppCubit>().confirmedUsername(newUser);
                  }
                },
                text: AppStrings.confirm,
              ),
          ],
        ),
      ),
    );
  }
}
