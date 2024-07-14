import 'package:flutter/material.dart';
import 'package:rando/components/activities/activity.dart';
import 'package:rando/services/firestore/item_service.dart';
import 'package:rando/services/models.dart';

class ActivityFeedWidget extends StatefulWidget {
  const ActivityFeedWidget({super.key});

  @override
  State<ActivityFeedWidget> createState() => _ActivityFeedWidgetState();
}

class _ActivityFeedWidgetState extends State<ActivityFeedWidget> {
  ItemService itemService = ItemService();
  late Stream<List<ItemData>> itemStream;

  @override
  void initState() {
    super.initState();
    itemStream = itemService.getAllItemStream();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ItemData>>(
      stream: itemService.getAllItemStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text("error: ${snapshot.error.toString()}"),
            ),
          );
        } else if (snapshot.hasData) {
          List<ItemData> items = snapshot.data!;
          return SliverList.separated(
            itemBuilder: (context, index) {
              ItemData item = items[index];
              return ActivityWidget(item: item);
            },
            separatorBuilder: (context, index) => const SizedBox(
              height: 20,
            ),
            itemCount: items.length,
          );
        } else {
          return const SliverToBoxAdapter(
            child: Text("No Lists Found in Firestore. Check Database"),
          );
        }
      },
    );
  }
}
