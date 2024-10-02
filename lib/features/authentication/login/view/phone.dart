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
    return CustomContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              prefixText: '+1 ',
              prefixStyle: const TextStyle(fontSize: 18),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
              ),
              labelStyle: TextStyle(
                color: Theme.of(context).subtextColor,
              ),
              label: const Text(AppStrings.phoneNumberPrompt),
              enabledBorder: OutlineInputBorder(
                borderRadius: defaultBorderRadius,
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 4,
                ),
              ),
            ),
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
                  context.showSnackBar(AppStrings.invalidPhoneNumber);
                  _phoneController.clear();
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
