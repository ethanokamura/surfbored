import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/authentication/login/cubit/authentication_cubit.dart';

class OtpPrompt extends StatefulWidget {
  const OtpPrompt({super.key});

  @override
  State<OtpPrompt> createState() => _OtpPromptState();
}

class _OtpPromptState extends State<OtpPrompt> {
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
              ),
              labelStyle: TextStyle(
                color: Theme.of(context).subtextColor,
              ),
              label: const Text(AppStrings.otpPrompt),
              enabledBorder: OutlineInputBorder(
                borderRadius: defaultBorderRadius,
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 4,
                ),
              ),
            ),
          ),
          ActionButton(
            onSurface: true,
            onTap: () async {
              try {
                final otp = _otpController.text.trim();
                if (otp.length == 6) {
                  await context.read<AuthCubit>().signInWithOTP(otp);
                } else {
                  context.showSnackBar(AppStrings.invalidOtp);
                  _otpController.clear();
                }
              } catch (e) {
                // handle error
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  context.showSnackBar('error occured. please retry');
                }
              }
            },
            text: AppStrings.confirm,
          ),
        ],
      ),
    );
  }
}
