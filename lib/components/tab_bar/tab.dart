import 'package:flutter/material.dart';

class CustomTabWidget extends StatelessWidget {
  final IconData icon;
  const CustomTabWidget({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
