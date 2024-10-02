import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  static Page<dynamic> page() => const MaterialPage<void>(child: SearchPage());

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // search bar controller
  final _searchTextController = TextEditingController();

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomPageView(
        top: false,
        body: Column(
          children: <Widget>[
            CustomContainer(
              vertical: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  defaultIconStyle(context, AppIcons.search),
                  const HorizontalSpacer(),
                  Expanded(
                    child: TextField(
                      controller: _searchTextController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search for something new',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const VerticalSpacer(),
            // Expanded(child: _results(context, _pagingController)),
          ],
        ),
      ),
    );
  }
}
