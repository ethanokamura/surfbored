import 'package:flutter/material.dart';
import 'package:rando/components/anon_wall.dart';
import 'package:rando/components/buttons/custom_button.dart';
import 'package:rando/services/auth.dart';

class SelectCreateScreen extends StatelessWidget {
  SelectCreateScreen({super.key});

  final user = AuthService().user!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: user.isAnonymous
          ? const AnonWallWidget(message: "Sign In To Create A Post")
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, bottom: 25, top: 20),
                child: Column(
                  children: [
                    Text(
                      "Create Something!",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomButton(
                              onTap: () => Navigator.pushNamed(
                                  context, '/create-activity'),
                              text: "create activity",
                            ),
                            const SizedBox(height: 10),
                            CustomButton(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/create-board'),
                              text: "create board",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
