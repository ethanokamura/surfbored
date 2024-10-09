import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
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
    if (username.length > 15 || username.length < 3) {
      setState(() => _isValid = false);
      return;
    }
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        _username = username;
      });
      final unique = await context
          .read<UserRepository>()
          .isUsernameUnique(username: username);
      setState(() {
        _isValid = unique;
      });
    });
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
            ActionButton(
              inverted: true,
              onTap: _isValid
                  ? () async {
                      await context
                          .read<UserRepository>()
                          .updateUsername(username: _username);
                      if (context.mounted) {
                        context.read<AppCubit>().reinitState();
                      }
                      _usernameController.clear();
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
