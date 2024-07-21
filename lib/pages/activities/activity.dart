import 'package:flutter/material.dart';
import 'package:rando/shared/activity.dart';
// import 'package:rando/components/buttons/defualt_button.dart';
// import 'package:rando/services/firestore/item_service.dart';
import 'package:rando/core/models/models.dart';

class ActivityScreen extends StatelessWidget {
  final ItemData item;
  const ActivityScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // ItemService itemService = ItemService();
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ActivityWidget(item: item),
          ),
        ),
      ),
    );
  }
}
