import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
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
      children: [
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            label: Text(AppStrings.phoneNumberPrompt),
          ),
        ),
        ActionButton(
          onTap: () async {
            try {
              final phoneNumber = _phoneController.text.trim();
              if (phoneNumber.length == 10) {
                await context
                    .read<AuthCubit>()
                    .signInWithPhone('+1$phoneNumber');
              } else {
                context.showSnackBar(AppStrings.invalidPhoneNumber);
                _phoneController.clear();
              }
            } catch (e) {
              // handle error
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('error occured. please retry')),
              );
            }
          },
          text: AppStrings.confirm,
        ),
      ],
    );
  }
}
