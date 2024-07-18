import 'package:flutter/material.dart';
import 'package:rando/utils/global.dart';
import 'package:rando/utils/theme/theme.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final bool inverted;
  final String? label;
  final void Function()? onTap;
  const CustomIconButton({
    super.key,
    this.label,
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
            size: 18,
          ),
        ),
        label != null ? Text("$label") : const SizedBox.shrink(),
      ],
    );
  }
}
