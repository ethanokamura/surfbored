import 'package:flutter/material.dart';

class BlockWidget extends StatelessWidget {
  final Widget child;
  const BlockWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 15,
      color: Theme.of(context).colorScheme.surface,
      shadowColor: Theme.of(context).shadowColor,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: child,
      ),
    );
  }
}
