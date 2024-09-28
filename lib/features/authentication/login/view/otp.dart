import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
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
    return Column(
      children: [
        TextFormField(
          controller: _otpController,
          decoration: const InputDecoration(
            label: Text(AppStrings.otpPrompt),
          ),
        ),
        ActionButton(
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
                context.showSnackBar('error occured. please retry');
              }
            }
          },
          text: AppStrings.confirm,
        ),
      ],
    );
  }
}
