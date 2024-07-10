// dart packages
import 'package:flutter/material.dart';
import 'package:rando/components/item.dart';

// ui
import 'package:rando/utils/theme/theme.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String label;
  final void Function()? onPressed;

  const MyTextBox(
      {super.key,
      required this.text,
      required this.label,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ItemWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
