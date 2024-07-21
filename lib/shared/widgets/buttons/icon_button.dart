import 'package:flutter/material.dart';
import 'package:rando/config/global.dart';
import 'package:rando/config/theme.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final bool inverted;
  final String? label;
  final double? size;
  final void Function()? onTap;
  const CustomIconButton({
    super.key,
    this.label,
    this.size,
    required this.icon,
    required this.inverted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
            elevation: 10,
            shadowColor: Colors.black,
            backgroundColor: inverted
                ? Theme.of(context).accentColor
                : Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          icon: Icon(
            icon,
            color: inverted
                ? Theme.of(context).inverseTextColor
                : Theme.of(context).textColor,
            size: size ?? 15,
          ),
        ),
        label != null ? const SizedBox(height: 5) : const SizedBox.shrink(),
        label != null
            ? Text(
                "$label",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).textColor,
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
