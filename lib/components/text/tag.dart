// dart pacakge
import 'package:flutter/material.dart';
import 'package:rando/components/block.dart';
import 'package:rando/utils/theme/theme.dart';

class TagWidget extends StatelessWidget {
  final String tag;
  const TagWidget({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return BlockWidget(
      inverted: true,
      horizontal: 10,
      vertical: 0,
      child: Text(
        tag,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Theme.of(context).inverseTextColor,
          fontSize: 14,
        ),
      ),
    );
  }
}
