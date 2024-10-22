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
  String _phoneNumber = '';
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
        customTextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          context: context,
          label: AuthStrings.phoneNumberPrompt,
          prefix: '+1 ',
          maxLength: 10,
          onChanged: (number) => setState(() => _phoneNumber = number.trim()),
          validator: (number) =>
              number?.length != 10 ? 'Invalid Phone Number' : null,
        ),
        const VerticalSpacer(multiple: 3),
        ActionButton(
          vertical: 10,
          onTap: _phoneNumber.length == 10
              ? () async {
                  try {
                    await context
                        .read<AuthCubit>()
                        .signInWithPhone('+1$_phoneNumber');
                  } catch (e) {
                    // handle error
                    if (!context.mounted) return;
                    context.showSnackBar('error occured. please retry');
                  }
                }
              : null,
          text: ButtonStrings.continueText,
        ),
      ],
    );
  }
}
