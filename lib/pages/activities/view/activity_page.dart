import 'package:flutter/material.dart';
import 'package:rando/shared/activity.dart';
import 'package:rando/core/models/models.dart';

class ActivityPage extends StatelessWidget {
  final ItemData item;
  const ActivityPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
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
