import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});
  static Page<dynamic> page() => const MaterialPage<void>(child: InboxPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPageView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ActionButton(
                  //   inverted: false,
                  //   onTap: () {},
                  //   icon: Icons.person,
                  // ),
                  Text(
                    'Inbox',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  // ActionButton(
                  //   inverted: false,
                  //   onTap: () {},
                  //   icon: Icons.add,
                  // ),
                ],
              ),
            ),
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
      ),
    );
  }
}
