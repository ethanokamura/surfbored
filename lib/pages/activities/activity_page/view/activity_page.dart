// import 'package:app_ui/app_ui.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import 'package:rando/pages/activities/shared/activity/activity.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({required this.itemID, super.key});
  static MaterialPage<void> page({
    required String itemID,
  }) {
    return MaterialPage<void>(
      child: ActivityPage(itemID: itemID),
    );
  }

  final String itemID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Screen'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Activity(itemID: itemID),
        ),
      ),
    );
  }
}
