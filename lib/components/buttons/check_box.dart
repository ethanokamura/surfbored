import 'package:flutter/material.dart';
import 'package:rando/utils/theme/theme.dart';

class CheckBox extends StatelessWidget {
  final bool isSelected;
  final void Function()? onTap;
  const CheckBox({
    super.key,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank,
        color: isSelected
            ? Theme.of(context).accentColor
            : Theme.of(context).backgroundColor,
      ),
    );
  }
}
