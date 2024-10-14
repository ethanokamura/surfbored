import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/authentication/login/cubit/authentication_cubit.dart';
import 'package:surfbored/features/authentication/login/view/otp.dart';
import 'package:surfbored/features/authentication/login/view/phone.dart';
import 'package:surfbored/features/failures/user_failures.dart';
import 'package:user_repository/user_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage._();
  static MaterialPage<dynamic> page() => const MaterialPage<void>(
        key: ValueKey('login_page'),
        child: LoginPage._(),
      );
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomPageView(
        appBar: AppBar(
          title: const AppBarText(text: AuthStrings.signIn),
          backgroundColor: Colors.transparent,
        ),
        top: true,
        body: BlocProvider(
          create: (context) => AuthCubit(
            userRepository: context.read<UserRepository>(),
          ),
          child: listenForUserFailures<AuthCubit, AuthState>(
            failureSelector: (state) => state.failure,
            isFailureSelector: (state) => state.isFailure,
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.needsOtp) {
                  return const Center(child: OtpPrompt());
                }
                return const Center(child: PhonePrompt());
              },
            ),
          ),
        ),
      ),
    );
  }
}
