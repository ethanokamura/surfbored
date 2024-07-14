import 'package:flutter/material.dart';
import 'package:rando/utils/theme/theme.dart';

class LinkWidget extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const LinkWidget({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
