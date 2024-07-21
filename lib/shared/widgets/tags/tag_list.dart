// dart package
import 'package:flutter/material.dart';

// components
import 'package:rando/shared/widgets/tags/tag.dart';

class TagListWidget extends StatelessWidget {
  final List<String> tags;
  const TagListWidget({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: tags.map((item) {
        return TagWidget(tag: item);
      }).toList(),
    );
  }
}
