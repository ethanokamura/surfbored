import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surfbored/features/authentication/login/cubit/authentication_cubit.dart';
import 'package:surfbored/features/authentication/login/view/otp.dart';
import 'package:surfbored/features/authentication/login/view/phone.dart';
import 'package:user_repository/user_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage._();
  static Page<dynamic> page() => const MaterialPage<void>(
        key: ValueKey('login_page'),
        child: LoginPage._(),
      );
  @override
  Widget build(BuildContext context) {
    print('login page');
    return CustomPageView(
      appBar: AppBar(
        title: const AppBarText(text: AppStrings.signIn),
      ),
      body: BlocProvider(
        create: (context) => AuthCubit(
          userRepository: context.read<UserRepository>(),
        ),
        child: BlocListener<AuthCubit, AuthState>(
          listenWhen: (_, current) => current.isFailure,
          listener: (context, state) {
            if (state.isFailure) {
              final message = switch (state.failure) {
                PhoneNumberSignInFailure() =>
                  AppStrings.phoneSignInFailureMessage,
                _ => AppStrings.unknownFailure,
              };
              return context.showSnackBar(message);
            }
          },
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.needsOtp) {
                return const OtpPrompt();
              }
              return const PhonePrompt();
            },
          ),
        ),
      ),
    );
  }
}
