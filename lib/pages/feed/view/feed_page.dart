import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rando/pages/activities/activity_feed/activity_feed.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});
  static Page<dynamic> page() => const MaterialPage<void>(child: FeedPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Feed'),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.solidPaperPlane),
            onPressed: () {},
          ),
        ],
      ),
      body: const CustomPageView(top: false, child: ActivityFeed()),
    );
  }
}
