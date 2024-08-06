import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});
  static Page<dynamic> page() => const MaterialPage<void>(child: InboxPage());

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: 'Inbox'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  borderRadius: defaultBorderRadius,
                  image: DecorationImage(
                    image: AssetImage(Theme.of(context).defaultImagePath),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
