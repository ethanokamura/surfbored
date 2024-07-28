import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  static Page<dynamic> page() => const MaterialPage<void>(child: SearchPage());

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: false,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CustomContainer(
                  inverted: false,
                  horizontal: null,
                  vertical: null,
                  child: Text(
                    'Search',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              const HorizontalSpacer(),
              ActionButton(
                inverted: false,
                onTap: () {},
                icon: FontAwesomeIcons.magnifyingGlass,
              ),
            ],
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
