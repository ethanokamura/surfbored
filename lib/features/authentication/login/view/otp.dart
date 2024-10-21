import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/app/cubit/app_cubit.dart';
import 'package:surfbored/features/authentication/login/cubit/authentication_cubit.dart';

class OtpPrompt extends StatefulWidget {
  const OtpPrompt({super.key});

  @override
  State<OtpPrompt> createState() => _OtpPromptState();
}

class _OtpPromptState extends State<OtpPrompt> {
  final _otpController = TextEditingController();
  String _otp = '';

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AppBarText(text: AuthStrings.otpPrompt),
        customTextFormField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          context: context,
          label: AuthStrings.otpHint,
          onChanged: (otp) => setState(() => _otp = otp.trim()),
          validator: (otp) => otp?.length != 6 ? 'Invalid OTP Code' : null,
        ),
        ActionButton(
          onTap: _otp.length == 6
              ? () async {
                  try {
                    await context.read<AuthCubit>().signInWithOTP(_otp);
                    if (!context.mounted) return;
                    context.read<AppCubit>().verifyUsernameExistence();
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
