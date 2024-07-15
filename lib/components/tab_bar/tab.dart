import 'package:flutter/material.dart';

class CustomTabWidget extends StatelessWidget {
  final Widget child;
  const CustomTabWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Tab(child: child);
  }
}
