import 'package:flutter/material.dart';

class PageNotFoundScreen extends StatelessWidget {
  const PageNotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found!'),
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
              'Oops! Page not found.',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
