import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/authentication/login/cubit/authentication_cubit.dart';

class PhonePrompt extends StatefulWidget {
  const PhonePrompt({super.key});

  @override
  State<PhonePrompt> createState() => _PhonePromptState();
}

class _PhonePromptState extends State<PhonePrompt> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppBarText(text: AuthStrings.signInPrompt),
        customTextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          context: context,
          label: AuthStrings.phoneNumberPrompt,
          prefix: '+1 ',
          validator: (phoneNumber) =>
              phoneNumber?.length != 10 ? 'Invalid Phone Number' : null,
        ),
        const VerticalSpacer(),
        ActionButton(
          onSurface: true,
          onTap: () async {
            try {
              final phoneNumber = _phoneController.text.trim();
              if (phoneNumber.length == 10) {
                await context
                    .read<AuthCubit>()
                    .signInWithPhone('+1$phoneNumber');
              } else {
                context.showSnackBar(AuthStrings.invalidPhoneNumber);
                _phoneController.clear();
              }
            } catch (e) {
              // handle error
              if (!context.mounted) return;
              context.showSnackBar('error occured. please retry');
            }
          },
          text: ButtonStrings.continueText,
        ),
      ],
    );
  }
}
