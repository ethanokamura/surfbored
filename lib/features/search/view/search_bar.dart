import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({required this.onTap, super.key});
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return SearchBar(
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: defaultBorderRadius),
      ),
      hintText: 'Find something new',
      hintStyle: WidgetStatePropertyAll(
        TextStyle(color: Theme.of(context).subtextColor),
      ),
      trailing: [
        ActionIconButton(
          icon: FontAwesomeIcons.magnifyingGlass,
          inverted: true,
          onTap: onTap,
        ),
      ],
    );
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton({required this.onTap, super.key});
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(10),
      elevation: 0,
      shadowColor: Colors.black,
      backgroundColor: Theme.of(context).accentColor,
      shape: const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onTap,
          style: style,
          icon: Icon(
            FontAwesomeIcons.magnifyingGlass,
            color: Theme.of(context).textColor,
            size: 15,
          ),
        ),
      ],
    );
  }
}
