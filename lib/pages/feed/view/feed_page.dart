import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rando/pages/activities/activity_feed/activity_feed.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Feed'),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: ActivityFeed(),
        ),
      ),
    );
  }
}
