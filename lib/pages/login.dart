// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// ui libraries
import 'package:rando/utils/theme/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          // center on screen
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const FlutterLogo(
              size: 150,
            ),
            Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'email',
                  ),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: 'password',
                  ),
                ),
              ],
            ),
            LoginButton(
              text: 'Sign In',
              icon: Icons.person,
              color: Theme.of(context).surfaceColor,
              loginMethod: () => AuthService().emailLogin(
                emailController.text.trim(),
                passwordController.text.trim(),
              ),
            ),
            LoginButton(
              text: 'Sign in with Google',
              icon: FontAwesomeIcons.google,
              loginMethod: AuthService().googleLogin,
              color: Theme.of(context).surfaceColor,
            ),
            FutureBuilder<Object>(
              future: SignInWithApple.isAvailable(),
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return SignInWithAppleButton(
                    onPressed: () {
                      AuthService().signInWithApple();
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  const LoginButton(
      {super.key,
      required this.text,
      required this.icon,
      required this.color,
      required this.loginMethod});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: Theme.of(context).onSurfaceColor,
          size: 20,
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(10),
          backgroundColor: color,
        ),
        onPressed: () => loginMethod(),
        label: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
