import 'package:flutter/material.dart';
import 'package:rando/features/tags/views/tag.dart';

class TagList extends StatelessWidget {
  const TagList({required this.tags, super.key});
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((item) {
        return Tag(tag: item);
      }).toList(),
    );
  }
}
