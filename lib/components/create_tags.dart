// dart package
import 'package:flutter/material.dart';

// components
import 'package:rando/components/tag.dart';

class CreateTagsWidget extends StatefulWidget {
  const CreateTagsWidget({super.key});

  @override
  State<CreateTagsWidget> createState() => _CreateTagsWidgetState();
}

class _CreateTagsWidgetState extends State<CreateTagsWidget> {
  final tagController = TextEditingController();
  List<String> tags = [];
  bool isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    tagController.addListener(_handleTextChanged);
  }

  void _handleTextChanged() {
    setState(() {
      isButtonDisabled = tagController.text.isEmpty;
    });
  }

  void addTag(String rawTag) {
    final tag = rawTag.trim();
    tags.add(tag);
    tagController.clear();
  }

  @override
  void dispose() {
    tagController.removeListener(_handleTextChanged);
    tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: TextField(
                  controller: tagController,
                  decoration: const InputDecoration(
                    hintText: 'tags',
                  ),
                ),
              ),
              if (tagController.text.isEmpty == false)
                ElevatedButton(
                  onPressed: isButtonDisabled
                      ? null
                      : () => addTag(tagController.text),
                  child: const Icon(Icons.add),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: tags.map((item) {
              return TagWidget(tag: item);
            }).toList(),
          ),
        ],
      ),
    );
  }
}
