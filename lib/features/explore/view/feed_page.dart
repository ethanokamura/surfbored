import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:surfbored/features/posts/posts.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});
  static Page<dynamic> page() => const MaterialPage<void>(child: FeedPage());

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: 'Activity Feed'),
      ),
      body: const PostFeed(),
    );
  }
}
