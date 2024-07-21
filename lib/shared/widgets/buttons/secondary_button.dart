import 'package:flutter/material.dart';
import 'package:rando/config/global.dart';
import 'package:rando/config/theme.dart';

class SecondaryButton extends StatelessWidget {
  final IconData? icon;
  final bool inverted;
  final String? text;
  final double? vertical;
  final double? horizontal;
  final void Function()? onTap;
  const SecondaryButton({
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
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal == null ? 15 : horizontal!,
          vertical: vertical == null ? 10 : vertical!,
        ),
        // elevation: 5,
        shadowColor: Colors.black,
        side: BorderSide(
          color: inverted
              ? Theme.of(context).accentColor
              : Theme.of(context).subtextColor,
          width: 3,
        ),
        backgroundColor: Colors.transparent,
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
                      ? Theme.of(context).accentColor
                      : Theme.of(context).textColor,
                  size: 18,
                )
              : const SizedBox.shrink(),
          text != null
              ? Text(
                  text!,
                  style: TextStyle(
                    color: inverted
                        ? Theme.of(context).accentColor
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
