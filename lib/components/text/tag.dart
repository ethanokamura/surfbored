// dart pacakge
import 'package:flutter/material.dart';
import 'package:rando/utils/theme/theme.dart';

class TagWidget extends StatelessWidget {
  final String tag;
  const TagWidget({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).accentColor,
      borderRadius: BorderRadius.circular(5),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Text(
          tag,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).inverseTextColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
