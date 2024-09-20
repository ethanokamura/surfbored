import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:surfbored/features/tags/tags.dart';

class EditTagsBox extends StatelessWidget {
  const EditTagsBox({required this.tags, required this.updateTags, super.key});
  final List<String> tags;
  final void Function(List<String>) updateTags;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
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
              const SecondaryText(text: AppStrings.editTags),
              ActionIconButton(
                inverted: true,
                icon: Icons.settings,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (context) => AddTagsPage(
                      tags: tags,
                      returnTags: updateTags,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // tags
          TagList(tags: tags),
        ],
      ),
    );
  }
}
