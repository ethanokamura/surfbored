import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:rando/pages/activities/activities.dart';

class ActivityGrid extends StatelessWidget {
  const ActivityGrid({required this.items, super.key});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: defaultPadding),
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final itemID = items[index];
        return ItemCard(itemID: itemID);
      },
    );
  }
}
