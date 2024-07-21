import 'package:flutter/material.dart';
import 'package:rando/shared/widgets/buttons/defualt_button.dart';
import 'package:rando/core/services/auth_service.dart';

class AnonWallWidget extends StatelessWidget {
  final String message;
  const AnonWallWidget({super.key, required this.message});

  // logout user
  void logOut(BuildContext context) async {
    await AuthService.signOut();
    // reset navigation stack
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            DefualtButton(
              inverted: true,
              onTap: () => logOut(context),
              text: "Login",
            ),
          ],
        ),
      ),
    );
  }
}
