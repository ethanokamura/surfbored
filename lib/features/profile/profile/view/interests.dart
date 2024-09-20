import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:surfbored/features/tags/tags.dart';

class InterestsList extends StatelessWidget {
  const InterestsList({required this.interests, super.key});
  final List<String> interests;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      inverted: false,
      horizontal: null,
      vertical: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SecondaryText(text: AppStrings.interests),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TagList(tags: interests),
          ),
        ],
      ),
    );
  }
}
