// dart packages
import 'package:flutter/material.dart';
import 'package:rando/components/buttons/custom_button.dart';

class CreateRedirect extends StatelessWidget {
  const CreateRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CustomButton(
            inverted: true,
            text: "Create Something!",
            onTap: () => Navigator.pushNamed(context, '/create'),
          ),
        ),
      ),
    );
  }
}
