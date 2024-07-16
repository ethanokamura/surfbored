import 'package:flutter/material.dart';
import 'package:rando/components/block.dart';
import 'package:rando/utils/theme/theme.dart';

class MyInputField extends StatelessWidget {
  final String label;
  final String text;
  final void Function()? onPressed;

  const MyInputField({
    super.key,
    required this.label,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: BlockWidget(
            inverted: false,
            horizontal: null,
            vertical: 0,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      text,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).accentColor,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  // splashColor: Colors.transparent,
                  // highlightColor: Colors.transparent,
                  tooltip: 'Edit',
                  iconSize: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
