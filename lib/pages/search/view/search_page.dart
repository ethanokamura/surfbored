import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rando/pages/search/view/search_bar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  static Page<dynamic> page() => const MaterialPage<void>(child: SearchPage());

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: false,
      child: Column(
        children: [
          MySearchBar(
            onTap: () {},
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
