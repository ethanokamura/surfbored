import 'package:flutter/material.dart';
import 'package:rando/components/anon_wall.dart';
import 'package:rando/services/auth.dart';
import 'package:rando/utils/theme/theme.dart';

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
                            ElevatedButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, '/create-activity'),
                              child: Text(
                                "create activity",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/create-board'),
                              child: Text(
                                "create board",
                                style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
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
