import 'package:flutter/material.dart';
import 'package:rando/utils/theme/theme.dart';

class BlockWidget extends StatelessWidget {
  final Widget child;
  final bool inverted;
  final double? horizontal;
  final double? vertical;
  const BlockWidget({
    super.key,
    required this.child,
    required this.inverted,
    required this.horizontal,
    required this.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: inverted == true
          ? Theme.of(context).accentColor
          : Theme.of(context).colorScheme.surface,
      shadowColor: Theme.of(context).shadowColor,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal == null ? 15 : horizontal!,
          vertical: vertical == null ? 10 : vertical!,
        ),
        child: child,
      ),
    );
  }
}
