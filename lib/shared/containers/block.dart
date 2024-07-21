import 'package:flutter/material.dart';
import 'package:rando/config/global.dart';
import 'package:rando/config/theme.dart';

class BlockWidget extends StatelessWidget {
  final bool inverted;
  final double? horizontal;
  final double? vertical;
  final Widget child;

  const BlockWidget({
    super.key,
    required this.inverted,
    required this.horizontal,
    required this.vertical,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: inverted == true
          ? Theme.of(context).accentColor
          : Theme.of(context).colorScheme.surface,
      shadowColor: Theme.of(context).shadowColor,
      borderRadius: borderRadius,
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
