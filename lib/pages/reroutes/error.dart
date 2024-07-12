import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error!'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline,
              size: 100,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              'There was an error! Please try again.',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
