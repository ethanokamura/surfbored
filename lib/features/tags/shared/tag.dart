import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  const Tag({required this.tag, super.key});
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: defaultElevation,
      color: Theme.of(context).colorScheme.primary,
      shadowColor: Theme.of(context).shadowColor,
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: PrimaryText(text: tag, fontSize: 14),
      ),
    );
  }
}
