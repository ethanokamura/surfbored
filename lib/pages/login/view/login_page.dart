import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/login/cubit/login_cubit.dart';
import 'package:user_repository/user_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage._();

  static Page<dynamic> page() => const MaterialPage<void>(
        key: ValueKey('login_page'),
        child: LoginPage._(),
      );

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: false,
      body: BlocProvider(
        create: (_) => LoginCubit(
          userRepository: context.read<UserRepository>(),
        ),
        child: const LoginContent(),
      ),
    );
  }
}

class LoginContent extends StatelessWidget {
  const LoginContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (_, current) => current.isFailure,
      listener: (context, state) {
        if (state.isFailure) {
          final message = switch (state.failure) {
            AnonymousSignInFailure() => AppStrings.anonSignInFailureMessage,
            PhoneNumberSignInFailure() => AppStrings.phoneSignInFailureMessage,
            _ => AppStrings.unknownFailure,
          };
          return context.showSnackBar(message);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Center(
            child: Text(
              'Locals Only',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Container(
              height: 128,
              width: 128,
              decoration: BoxDecoration(
                borderRadius: defaultBorderRadius,
                image: DecorationImage(
                  image: AssetImage(Theme.of(context).defaultImagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const VerticalSpacer(),
          const PhoneSignIn(),
          const AnonymousSignInButton(),
        ],
      ),
    );
  }
}

class PhoneSignIn extends StatefulWidget {
  const PhoneSignIn({super.key});

  @override
  State<PhoneSignIn> createState() => _PhoneSignInState();
}

class _PhoneSignInState extends State<PhoneSignIn> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _codeSent = false;
  String? _verificationId;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              if (!_codeSent)
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                  ),
                )
              else
                TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Verification Code',
                  ),
                ),
              const SizedBox(height: 16),
              SignInButton(
                inverted: true,
                onTap: () async {
                  setState(() => isLoading = true);
                  if (!_codeSent) {
                    await context.read<LoginCubit>().signInWithPhone(
                          phoneNumber: _phoneController.text.trim(),
                          verificationCompleted: (credential) async {
                            await context.read<LoginCubit>().signInWithOTP(
                                  _codeController.text.trim(),
                                  _verificationId,
                                );
                          },
                          verificationFailed: (exception) {
                            // Error handling is managed by BlocListener
                            // print('verification failed');
                            context.showSnackBar('Error Verifying. Try Again.');
                          },
                          codeSent: (String verificationId,
                              [forceResendingToken]) {
                            setState(() {
                              _verificationId = verificationId;
                              _codeSent = true;
                              _phoneController.clear();
                            });
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {
                            setState(() {
                              _verificationId = verificationId;
                            });
                          },
                        );
                    setState(() => isLoading = false);
                  } else {
                    await context.read<LoginCubit>().signInWithOTP(
                          _codeController.text.trim(),
                          _verificationId,
                        );
                    setState(() => isLoading = false);
                  }
                },
                text: isLoading
                    ? 'Loading'
                    : !_codeSent
                        ? 'Send Code'
                        : 'Sign In',
              ),
            ],
          );
  }
}

class AnonymousSignInButton extends StatelessWidget {
  const AnonymousSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isSigningInAnonymously = context.select<LoginCubit, bool>(
      (cubit) => cubit.state.isSigningInAnonymously,
    );
    return SignInButton(
      inverted: false,
      text: AppStrings.guestText,
      processing: isSigningInAnonymously,
      onTap: isSigningInAnonymously
          ? null
          : () => context.read<LoginCubit>().signInAnonymously(),
    );
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({
    required this.text,
    required this.onTap,
    required this.inverted,
    this.processing = false,
    super.key,
  });

  final String text;
  final bool processing;
  final bool inverted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ActionButton(
      inverted: inverted,
      onTap: onTap,
      text: processing ? 'Loading' : text,
    );
  }
}
