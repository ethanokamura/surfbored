import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 25,
              right: 25,
              bottom: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActionButton(
                  inverted: false,
                  onTap: () {},
                  icon: Icons.person,
                ),
                Text(
                  AppStrings.appTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ActionButton(
                  inverted: false,
                  onTap: () {},
                  icon: Icons.add,
                ),
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
    );
  }
}
