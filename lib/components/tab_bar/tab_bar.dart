import 'package:flutter/material.dart';
import 'package:rando/utils/theme/theme.dart';

class CustomTabBarWidget extends StatelessWidget {
  final List<Widget> tabs;
  const CustomTabBarWidget({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
          color: Theme.of(context).surfaceColor,
          borderRadius: BorderRadius.circular(8)),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(8),
        ),
        labelColor: Theme.of(context).inverseTextColor,
        unselectedLabelColor: Theme.of(context).textColor,
        tabs: tabs,
      ),
    );
  }
}
