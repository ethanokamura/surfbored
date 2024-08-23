import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/features/profile/cubit/profile_cubit.dart';
import 'package:rando/features/tags/tags.dart';
import 'package:user_repository/user_repository.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({required this.userID, super.key});

  static MaterialPage<void> page({required String userID}) {
    return MaterialPage<void>(
      child: EditProfilePage(userID: userID),
    );
  }

  final String userID;

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: 'Edit Profile'),
      ),
      body: BlocBuilder<ProfileCubit, User>(
        builder: (context, user) {
          return EditProfile(user: user);
        },
      ),
    );
  }
}

class EditProfile extends StatelessWidget {
  const EditProfile({required this.user, super.key});
  final User user;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          EditSquareImage(
            width: 200,
            height: 200,
            photoURL: user.photoURL,
            collection: 'users',
            docID: user.uid,
            onFileChanged: (url) {
              context.read<ProfileCubit>().editField('photoURL', url);
            },
          ),
          const VerticalSpacer(),
          CustomTextBox(
            text: user.username,
            label: 'username',
            onPressed: () async {
              final newValue = await editTextField(
                context,
                'username',
                20,
                TextEditingController(),
              );
              if (newValue != null && context.mounted) {
                await context
                    .read<ProfileCubit>()
                    .editField('username', newValue);
              }
            },
          ),
          const VerticalSpacer(),
          CustomTextBox(
            text: user.name,
            label: 'name',
            onPressed: () async {
              final newValue = await editTextField(
                context,
                'name',
                30,
                TextEditingController(),
              );
              if (newValue != null && context.mounted) {
                await context.read<ProfileCubit>().editField('name', newValue);
              }
            },
          ),
          const VerticalSpacer(),
          CustomTextBox(
            text: user.bio,
            label: 'bio',
            onPressed: () async {
              final newValue = await editTextField(
                context,
                'bio',
                30,
                TextEditingController(),
              );
              if (newValue != null && context.mounted) {
                await context.read<ProfileCubit>().editField('bio', newValue);
              }
            },
          ),
          const VerticalSpacer(),
          EditTagsBox(
            tags: user.tags,
            updateTags: (newTags) =>
                context.read<ProfileCubit>().editField('tags', newTags),
          ),
        ],
      ),
    );
  }
}
