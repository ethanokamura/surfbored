import 'package:flutter/material.dart';
import 'package:rando/components/activities/activity.dart';
import 'package:rando/components/buttons/defualt_button.dart';
import 'package:rando/services/firestore/item_service.dart';
import 'package:rando/services/models.dart';

class ActivityScreen extends StatelessWidget {
  final String itemID;
  const ActivityScreen({super.key, required this.itemID});

  Future<ItemData> getItemData() async {
    return await ItemService().getItem(itemID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text(item.title),
          ),
      body: FutureBuilder<ItemData>(
        future: getItemData(),
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
                          child: DefualtButton(
                            inverted: false,
                            onTap: () {},
                            text: 'X',
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: DefualtButton(
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
