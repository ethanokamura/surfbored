import 'package:flutter/material.dart';
import 'package:rando/config/global.dart';
import 'package:rando/config/theme.dart';

class CustomTabBarWidget extends StatelessWidget {
  final List<Widget> tabs;
  const CustomTabBarWidget({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: borderRadius,
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: borderRadius,
        ),
        labelColor: Theme.of(context).textColor,
        unselectedLabelColor: Theme.of(context).subtextColor,
        tabs: tabs,
      ),
    );
  }
}
