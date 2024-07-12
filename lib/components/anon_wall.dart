import 'package:flutter/material.dart';
import 'package:rando/services/auth.dart';
import 'package:rando/utils/theme/theme.dart';

class AnonWallWidget extends StatelessWidget {
  final String message;
  const AnonWallWidget({super.key, required this.message});

  // logout user
  void logOut(BuildContext context) async {
    await AuthService().signOut();
    // reset navigation stack
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            ElevatedButton(
              onPressed: () => logOut(context),
              child: Text(
                "Login",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
