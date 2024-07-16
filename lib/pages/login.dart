// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// ui libraries
import 'package:rando/utils/theme/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            // center on screen
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Center(
                child: Text(
                  "Locals Only",
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
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(Theme.of(context).defaultImagePath),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  LoginButton(
                    text: 'Continue Annonymously',
                    icon: FontAwesomeIcons.userNinja,
                    color: Theme.of(context).colorScheme.surface,
                    loginMethod: () => AuthService().anonLogin(),
                  ),
                  LoginButton(
                    text: 'Sign in with Google',
                    icon: FontAwesomeIcons.google,
                    loginMethod: AuthService().googleLogin,
                    color: Theme.of(context).colorScheme.surface,
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
            ],
          ),
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
          color: Theme.of(context).textColor,
          size: 20,
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(10),
          backgroundColor: color,
        ),
        onPressed: () => loginMethod(),
        label: Text(
          text,
          style: TextStyle(color: Theme.of(context).textColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
