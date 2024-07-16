// dart packages
import 'package:flutter/material.dart';
import 'package:rando/components/block.dart';

// ui
import 'package:rando/utils/theme/theme.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String label;
  final void Function()? onPressed;

  const MyTextBox({
    super.key,
    required this.text,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlockWidget(
      inverted: false,
      horizontal: null,
      vertical: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // section name
              Text(
                label,
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.settings),
                color: Theme.of(context).accentColor,
              ),
            ],
          ),
          // text
          Text(text),
        ],
      ),
    );
  }
}
