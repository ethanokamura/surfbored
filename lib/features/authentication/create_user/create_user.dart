import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/app/cubit/app_cubit.dart';
import 'package:user_repository/user_repository.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage._();

  static MaterialPage<dynamic> page() => const MaterialPage<void>(
        key: ValueKey('create_user_page'),
        child: CreateUserPage._(),
      );

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _usernameController = TextEditingController();
  Timer? _debounce;
  bool _isValid = false;
  String _username = '';

  @override
  void dispose() {
    _usernameController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _onUsernameChanged(BuildContext context, String username) async {
    // use regex
    if (username.length > 15 || username.length < 3) {
      setState(() => _isValid = false);
      return;
    } else {
      setState(() {
        _isValid = true;
        _username = username;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: UserStrings.createUsername),
      ),
      top: true,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            customTextFormField(
              controller: _usernameController,
              context: context,
              onChanged: (value) async => _onUsernameChanged(
                context,
                value.trim(),
              ),
              label: CreateStrings.usernamePrompt,
            ),
            const VerticalSpacer(),
            ActionAccentButton(
              onTap: _isValid
                  ? () async {
                      final unique = await context
                          .read<UserRepository>()
                          .isUsernameUnique(username: _username);
                      if (!context.mounted) return;
                      if (unique) {
                        // change username
                        await context
                            .read<UserRepository>()
                            .updateUsername(username: _username);

                        // change this
                        if (!context.mounted) return;
                        context.read<AppCubit>().usernameSubmitted();
                      } else {
                        // add some sort of animation
                        context.showSnackBar(CreateStrings.invalidUsername);
                      }
                    }
                  : null,
              text: _isValid
                  ? ButtonStrings.continueText
                  : CreateStrings.invalidUsername,
            ),
          ],
        ),
      ),
    );
  }
}
