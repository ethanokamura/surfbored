import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:surfbored/app/cubit/app_cubit.dart';
import 'package:user_repository/user_repository.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage._();

  static Page<dynamic> page() => const MaterialPage<void>(
        key: ValueKey('create_user_page'),
        child: CreateUserPage._(),
      );

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  String username = '';

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: AppStrings.createUsername),
      ),
      top: true,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomInputField(
              label: AppStrings.username,
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
                      .isUsernameUnique(username: newValue);
                  if (isUnique) {
                    setState(() => username = newValue);
                  }
                }
              },
            ),
            const VerticalSpacer(),
            if (username.isNotEmpty)
              ActionButton(
                inverted: true,
                onTap: () async {
                  final newUser = await context
                      .read<UserRepository>()
                      .createUser(username: username);
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
