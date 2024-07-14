import 'package:flutter/material.dart';
import 'package:rando/utils/theme/theme.dart';

class CustomButton extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final void Function()? onTap;
  const CustomButton({
    super.key,
    this.icon,
    this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Material(
          elevation: 5,
          color: Theme.of(context).surfaceColor,
          shadowColor: Theme.of(context).shadowColor,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                icon != null
                    ? Icon(
                        icon,
                        color: Theme.of(context).textColor,
                        size: 18,
                      )
                    : const SizedBox.shrink(),
                text != null
                    ? Text(
                        text!,
                        style: TextStyle(
                          color: Theme.of(context).textColor,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
