import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/images/images.dart';
import 'package:surfbored/features/profile/cubit/profile_cubit.dart';
import 'package:surfbored/features/profile/profile_cubit_wrapper.dart';
import 'package:surfbored/features/tags/tags.dart';
import 'package:user_repository/user_repository.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  static MaterialPage<void> page() =>
      const MaterialPage<void>(child: EditProfilePage());

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: context.l10n.editProfilePage,
      body: ProfileCubitWrapper(
        defaultFunction: (context, state) => EditProfileView(user: state.user),
      ),
    );
  }
}

class EditProfileView extends StatefulWidget {
  const EditProfileView({required this.user, super.key});
  final UserData user;

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _usernameController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();

  bool _usernameIsValid = false;
  bool _displayNameIsValid = false;
  bool _bioIsValid = false;
  bool _interestsAreValid = false;
  String? _username;
  String? _displayName;
  String? _interests;
  String? _bio;
  late String? _photoUrl;

  @override
  void initState() {
    _usernameController.text = widget.user.username;
    _displayNameController.text = widget.user.displayName;
    _bioController.text = widget.user.bio;
    _photoUrl = widget.user.photoUrl;
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _onUsernameChanged(String username) async {
    // use regex
    if (username.length < 16 &&
        username.length > 2 &&
        username != widget.user.username) {
      setState(() {
        _usernameIsValid = true;
        _username = username;
      });
    } else {
      setState(() => _usernameIsValid = false);
    }
  }

  Future<void> _onDisplayNameChanged(String displayName) async {
    // use regex
    if (displayName.length < 20 &&
        displayName.isNotEmpty &&
        displayName != widget.user.displayName) {
      setState(() {
        _displayNameIsValid = true;
        _displayName = displayName;
      });
    } else {
      setState(() => _displayNameIsValid = false);
    }
  }

  Future<void> _onBioChanged(String bio) async {
    // use regex
    if (bio.length < 150 && bio.length > 1 && bio != widget.user.bio) {
      setState(() {
        _bioIsValid = true;
        _bio = bio;
      });
    } else {
      setState(() => _bioIsValid = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: EditProfileImage(
              width: 200,
              photoUrl: _photoUrl,
              userId: widget.user.uuid,
              onFileChanged: (url) async {
                await context
                    .read<ProfileCubit>()
                    .editField(UserData.photoUrlConverter, url);
                setState(() => _photoUrl = url);
              },
              aspectX: 1,
              aspectY: 1,
            ),
          ),
          const VerticalSpacer(),
          customTextFormField(
            controller: _usernameController,
            context: context,
            label: context.l10n.username,
            maxLength: 15,
            onChanged: (value) async => _onUsernameChanged(value.trim()),
            validator: (name) =>
                name != null && name.length < 3 && name.length > 20
                    ? 'Invalid Username'
                    : null,
          ),
          const VerticalSpacer(),
          customTextFormField(
            controller: _displayNameController,
            context: context,
            label: context.l10n.displayName,
            maxLength: 20,
            onChanged: (value) async => _onDisplayNameChanged(value.trim()),
          ),
          const VerticalSpacer(),
          customTextFormField(
            controller: _bioController,
            context: context,
            label: context.l10n.bio,
            maxLength: 150,
            onChanged: (value) async => _onBioChanged(value.trim()),
          ),
          const VerticalSpacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: context.l10n.interestsPrompt,
                fontSize: 22,
                style: primaryText,
              ),
              CustomButton(
                icon: AppIcons.edit,
                onTap: () => Navigator.push(
                  context,
                  bottomSlideTransition(
                    AddTagsPage(
                      tags: widget.user.interests.split('+'),
                      label: context.l10n.interestsPrompt,
                      returnTags: (interests) {
                        setState(() {
                          _interests = interests.join('+');
                          _interestsAreValid = true;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_interests != null && _interests!.isNotEmpty)
            TagList(tags: _interests!.split('+')),
          const VerticalSpacer(),
          CustomButton(
            color: 2,
            text: _bioIsValid ||
                    _usernameIsValid ||
                    _displayNameIsValid ||
                    _interestsAreValid
                ? context.l10n.save
                : context.l10n.invalid,
            onTap: _bioIsValid ||
                    _usernameIsValid ||
                    _displayNameIsValid ||
                    _interestsAreValid
                ? () async {
                    if (_username != null) {
                      final unique = await context
                          .read<UserRepository>()
                          .isUsernameUnique(username: _username!);
                      if (!context.mounted) return;
                      if (!unique) {
                        context.showSnackBar(context.l10n.invalidUsername);
                        return;
                      }
                    }
                    try {
                      final data = UserData.insert(
                        username: _username,
                        displayName: _displayName,
                        bio: _bio,
                        interests: _interests,
                      );
                      await context.read<ProfileCubit>().saveChanges(data);
                      if (!context.mounted) return;
                      context.showSnackBar(context.l10n.success);
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    } catch (e) {
                      if (!context.mounted) return;
                      context.showSnackBar('Unable to save data: $e');
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
