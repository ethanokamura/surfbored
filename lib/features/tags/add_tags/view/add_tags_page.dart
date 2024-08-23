import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rando/features/tags/shared/tag_list.dart';

class AddTagsPage extends StatelessWidget {
  const AddTagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: 'Add Tags'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            TagList(tags: []),
          ],
        ),
      ),
    );
  }
}
