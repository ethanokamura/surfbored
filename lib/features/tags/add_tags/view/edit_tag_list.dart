import 'package:flutter/material.dart';
import 'package:surfbored/features/tags/add_tags/view/edit_tag.dart';

class EditTagList extends StatelessWidget {
  const EditTagList({required this.tags, required this.onDelete, super.key});
  final List<String> tags;
  final void Function(String) onDelete;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((item) {
        return EditTag(
          tag: item,
          onDelete: onDelete,
        );
      }).toList(),
    );
  }
}
