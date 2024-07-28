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
    return Scaffold(
      body: CustomPageView(
        child: BlocProvider(
          create: (_) => LoginCubit(
            userRepository: context.read<UserRepository>(),
          ),
          child: const LoginContent(),
        ),
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
          const FlutterLogo(size: 150),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_codeSent)
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
        PhoneSignInButton(
          inverted: true,
          onTap: () async {
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
                    },
                    codeSent: (String verificationId, [forceResendingToken]) {
                      setState(() {
                        _verificationId = verificationId;
                        _codeSent = true;
                      });
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {
                      setState(() {
                        _verificationId = verificationId;
                      });
                    },
                  );
            } else {
              await context.read<LoginCubit>().signInWithOTP(
                    _codeController.text.trim(),
                    _verificationId,
                  );
            }
          },
          text: context.watch<LoginCubit>().state.isVerifyingWithPhone
              ? 'Loading'
              : !_codeSent
                  ? 'Send Code'
                  : 'Sign In',
        ),
      ],
    );
  }
}

class PhoneSignInButton extends StatelessWidget {
  const PhoneSignInButton({
    required this.inverted,
    required this.onTap,
    super.key,
    this.icon,
    this.text,
    this.vertical,
    this.horizontal,
  });

  final IconData? icon;
  final bool inverted;
  final String? text;
  final double? vertical;
  final double? horizontal;
  final Future<void> Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal == null ? 15 : horizontal!,
          vertical: vertical == null ? 10 : vertical!,
        ),
        elevation: 10,
        shadowColor: Colors.black,
        backgroundColor: inverted
            ? Theme.of(context).accentColor
            : Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: inverted
                  ? Theme.of(context).inverseTextColor
                  : Theme.of(context).textColor,
              size: 18,
            ),
          if (text != null && icon != null) const SizedBox(width: 10),
          if (text != null)
            Text(
              text!,
              style: TextStyle(
                color: inverted
                    ? Theme.of(context).inverseTextColor
                    : Theme.of(context).textColor,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
        ],
      ),
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
      text: AppStrings.guestText,
      processing: isSigningInAnonymously,
      onPressed: isSigningInAnonymously
          ? null
          : () => context.read<LoginCubit>().signInAnonymously(),
    );
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.icon,
    this.color,
    this.processing = false,
  });

  final String text;
  final IconData? icon;
  final Color? color;
  final bool processing;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final style = TextButton.styleFrom(
      backgroundColor: color,
    );
    final child = AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: processing
          ? const CircularProgressIndicator()
          : Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
            ),
    );
    if (icon != null) {
      return TextButton.icon(
        style: style,
        icon: Icon(icon),
        onPressed: onPressed,
        label: Expanded(child: child),
      );
    }
    return TextButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
