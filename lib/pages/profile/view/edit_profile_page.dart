// dart packages
import 'package:flutter/material.dart';

// data
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/profile_bloc.dart';
import '../data/profile_event.dart';
import '../data/profile_state.dart';

// utils
import 'package:rando/core/utils/methods.dart';

// components
import 'package:rando/shared/images/edit_image.dart';
import 'package:rando/shared/widgets/text/text_box.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileError) {
            return Center(child: Text("ERROR: ${state.error}"));
          } else if (state is ProfileLoaded) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      EditImage(
                        width: 200,
                        height: 200,
                        imgURL: state.userData.imgURL,
                        collection: 'users',
                        docID: state.userData.uid,
                        onFileChanged: (url) {
                          context
                              .read<ProfileBloc>()
                              .add(UpdateProfileField('imgURL', url));
                        },
                      ),
                      const SizedBox(height: 20),
                      MyTextBox(
                        text: state.userData.username,
                        label: "username",
                        onPressed: () async {
                          final newValue = await editTextField(
                            context,
                            'username',
                            20,
                            TextEditingController(),
                          );
                          if (newValue != null && context.mounted) {
                            context
                                .read<ProfileBloc>()
                                .add(UpdateProfileField('username', newValue));
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      MyTextBox(
                        text: state.userData.name,
                        label: "name",
                        onPressed: () async {
                          final newValue = await editTextField(
                            context,
                            'name',
                            30,
                            TextEditingController(),
                          );
                          if (newValue != null && context.mounted) {
                            context
                                .read<ProfileBloc>()
                                .add(UpdateProfileField('name', newValue));
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      MyTextBox(
                        text: state.userData.website,
                        label: "website",
                        onPressed: () async {
                          final newValue = await editTextField(
                            context,
                            'website',
                            30,
                            TextEditingController(),
                          );
                          if (newValue != null && context.mounted) {
                            context
                                .read<ProfileBloc>()
                                .add(UpdateProfileField('website', newValue));
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      MyTextBox(
                        text: state.userData.bio,
                        label: "bio",
                        onPressed: () async {
                          final newValue = await editTextField(
                            context,
                            'bio',
                            30,
                            TextEditingController(),
                          );
                          if (newValue != null && context.mounted) {
                            context
                                .read<ProfileBloc>()
                                .add(UpdateProfileField('bio', newValue));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Text("No user found");
        },
      ),
    );
  }
}
