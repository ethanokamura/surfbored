import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  void _onUsernameChanged(String username) {
    // use regex
    if (username.length < 15 && username.length > 3) {
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomPageView(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBarText(text: AppLocalizations.of(context)!.usernameTitle),
              const VerticalSpacer(multiple: 3),
              customTextFormField(
                controller: _usernameController,
                context: context,
                label: AppLocalizations.of(context)!.usernamePrompt,
                maxLength: 15,
                onChanged: (value) => _onUsernameChanged(
                  value.trim(),
                ),
                validator: (name) =>
                    name != null && (name.length < 3 || name.length > 20)
                        ? 'Invalid Username'
                        : null,
              ),
              const VerticalSpacer(multiple: 3),
              ActionButton(
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
                          context.showSnackBar(
                              AppLocalizations.of(context)!.invalidUsername);
                        }
                      }
                    : null,
                text: _isValid
                    ? AppLocalizations.of(context)!.next
                    : AppLocalizations.of(context)!.invalidUsername,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
