import 'package:flutter/material.dart';
import 'package:rando/config/global.dart';
import 'package:rando/config/theme.dart';

class DefualtButton extends StatelessWidget {
  final IconData? icon;
  final bool inverted;
  final String? text;
  final double? vertical;
  final double? horizontal;
  final void Function()? onTap;
  const DefualtButton({
    super.key,
    this.icon,
    this.text,
    this.vertical,
    this.horizontal,
    required this.inverted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal == null ? 15 : horizontal!,
          vertical: vertical == null ? 10 : vertical!,
        ),
        elevation: 10,
        shadowColor: Colors.black,
        backgroundColor: inverted
            ? Theme.of(context).accentColor
            : Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          icon != null
              ? Icon(
                  icon,
                  color: inverted
                      ? Theme.of(context).inverseTextColor
                      : Theme.of(context).textColor,
                  size: 18,
                )
              : const SizedBox.shrink(),
          text != null && icon != null
              ? const SizedBox(width: 10)
              : const SizedBox.shrink(),
          text != null
              ? Text(
                  text!,
                  style: TextStyle(
                    color: inverted
                        ? Theme.of(context).inverseTextColor
                        : Theme.of(context).textColor,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
