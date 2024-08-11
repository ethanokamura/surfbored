import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class InterestsList extends StatelessWidget {
  const InterestsList({super.key});

  @override
  Widget build(BuildContext context) {
    final interests = <String>[
      'tattoos',
      'dates',
      'outdoors',
      'food',
      'cats',
      'movies',
    ];
    return CustomContainer(
      inverted: false,
      horizontal: null,
      vertical: null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SecondaryText(text: 'interests'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TagList(tags: interests),
          ),
        ],
      ),
    );
  }
}
