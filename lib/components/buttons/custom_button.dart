import 'package:flutter/material.dart';
import 'package:rando/components/containers/block.dart';
import 'package:rando/utils/theme/theme.dart';

class CustomButton extends StatelessWidget {
  final bool inverted;
  final IconData? icon;
  final String? text;
  final void Function()? onTap;
  const CustomButton({
    super.key,
    required this.inverted,
    this.icon,
    this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: BlockWidget(
          vertical: null,
          horizontal: null,
          inverted: inverted,
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
                          : Theme.of(context).subtextColor,
                      size: 18,
                    )
                  : const SizedBox.shrink(),
              text != null
                  ? Text(
                      text!,
                      style: TextStyle(
                        color: inverted
                            ? Theme.of(context).inverseTextColor
                            : Theme.of(context).subtextColor,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ));
  }
}
