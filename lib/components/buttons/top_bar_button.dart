import 'package:flutter/material.dart';
import 'package:rando/utils/theme/theme.dart';

class TopBarButton extends StatelessWidget {
  final IconData? icon;
  final bool inverted;
  final String? text;
  final void Function()? onTap;
  const TopBarButton({
    super.key,
    this.icon,
    this.text,
    required this.inverted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                  size: 25,
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
