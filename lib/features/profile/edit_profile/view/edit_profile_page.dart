import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surfbored/features/profile/cubit/profile_cubit.dart';
import 'package:surfbored/features/tags/tags.dart';
import 'package:tag_repository/tag_repository.dart';
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
        title: const AppBarText(text: AppStrings.editProfile),
      ),
      body: BlocBuilder<ProfileCubit, UserData>(
        builder: (context, user) {
          return EditProfile(user: user);
        },
      ),
    );
  }
}

class EditProfile extends StatelessWidget {
  const EditProfile({required this.user, super.key});
  final UserData user;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          EditSquareImage(
            width: 200,
            height: 200,
            photoURL: user.photoUrl,
            collection: 'users',
            docID: user.id,
            onFileChanged: (url) =>
                context.read<ProfileCubit>().editField('photo_url', url),
          ),
          const VerticalSpacer(),
          CustomTextBox(
            text: user.username,
            label: 'username',
            onPressed: () async {
              final newValue = await editTextField(
                context,
                'username',
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
            text: user.displayName,
            label: 'name',
            onPressed: () async {
              final newValue = await editTextField(
                context,
                'name',
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
                TextEditingController(),
              );
              if (newValue != null && context.mounted) {
                await context.read<ProfileCubit>().editField('bio', newValue);
              }
            },
          ),
          const VerticalSpacer(),
          CustomTextBox(
            text: user.websiteUrl,
            label: 'website',
            onPressed: () async {
              final newValue = await editTextField(
                context,
                'website',
                TextEditingController(),
              );
              if (newValue != null && context.mounted) {
                await context
                    .read<ProfileCubit>()
                    .editField('website', newValue);
              }
            },
          ),
          const VerticalSpacer(),
          FutureBuilder<List<String>>(
            future: _getUserTags(user.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: PrimaryText(text: AppStrings.fetchFailure),
                );
              }
              final tags = snapshot.data;
              return EditTagsBox(
                tags: tags!,
                updateTags: (newTags) =>
                    context.read<ProfileCubit>().editField('tags', newTags),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<List<String>> _getUserTags(String uuid) async =>
      TagRepository().readUserTags(uuid);
}
