import 'package:flutter/material.dart';
import 'package:rando/components/activities/activity.dart';
import 'package:rando/components/buttons/custom_button.dart';
import 'package:rando/services/firestore/item_service.dart';
import 'package:rando/services/models.dart';

class ActivityScreen extends StatelessWidget {
  final ItemData item;
  const ActivityScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    ItemService itemService = ItemService();
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: StreamBuilder<ItemData>(
        stream: itemService.getItemStream(item.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Item Not Found."));
          }

          ItemData itemData = snapshot.data!;
          return SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ActivityWidget(item: itemData),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            inverted: false,
                            onTap: () {},
                            text: 'X',
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: CustomButton(
                            inverted: true,
                            onTap: () {},
                            icon: Icons.favorite,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
