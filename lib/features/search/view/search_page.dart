import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rando/features/search/view/search_bar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  static Page<dynamic> page() => const MaterialPage<void>(child: SearchPage());

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: false,
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            MySearchBar(onTap: () {}),
            const VerticalSpacer(),
            const SearchResultTabBar(),
            const VerticalSpacer(),
            const Expanded(
              child: TabBarView(
                children: [
                  CustomPlaceholder(),
                  CustomPlaceholder(),
                  CustomPlaceholder(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResultTabBar extends StatelessWidget {
  const SearchResultTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomTabBarWidget(
      tabs: [
        CustomTabWidget(
          child: Icon(
            // Icons.photo_library_outlined,
            Icons.photo_library_outlined,
            size: 20,
          ),
        ),
        CustomTabWidget(
          child: Icon(
            Icons.list,
            size: 20,
          ),
        ),
        CustomTabWidget(
          child: Icon(
            Icons.people_alt_outlined,
            size: 20,
          ),
        ),
      ],
    );
  }
}

class CustomPlaceholder extends StatelessWidget {
  const CustomPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
    );
  }
}
