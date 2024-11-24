import 'package:app_ui/src/constants.dart';
import 'package:app_ui/src/icons.dart';
import 'package:app_ui/src/text.dart';
import 'package:app_ui/src/theme.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    required this.child,
    this.inverted,
    this.horizontal,
    this.vertical,
    super.key,
  });

  final bool? inverted;
  final double? horizontal;
  final double? vertical;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: inverted != null && inverted!
          ? Theme.of(context).accentColor
          : Theme.of(context).colorScheme.surface,
      shadowColor: Theme.of(context).shadowColor,
      borderRadius: defaultBorderRadius,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal == null ? 15 : horizontal!,
          vertical: vertical == null ? 10 : vertical!,
        ),
        child: child,
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  const CustomInputField({
    required this.label,
    required this.text,
    required this.onPressed,
    super.key,
  });

  final String label;
  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      vertical: 0,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: PrimaryText(text: text),
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: accentIconStyle(context, AppIcons.edit),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            // splashColor: Colors.transparent,
            // highlightColor: Colors.transparent,
            tooltip: 'Edit',
            iconSize: 20,
          ),
        ],
      ),
    );
  }
}

class CustomTextBox extends StatelessWidget {
  const CustomTextBox({
    required this.text,
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String text;
  final String label;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CustomContainer(
        inverted: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SecondaryText(text: label),
                accentIconStyle(context, AppIcons.edit),
              ],
            ),
            // text
            PrimaryText(text: text),
          ],
        ),
      ),
    );
  }
}

class CustomTabWidget extends StatelessWidget {
  const CustomTabWidget({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tab(child: child);
  }
}

class CustomTabBarWidget extends StatelessWidget {
  const CustomTabBarWidget({required this.tabs, super.key});
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: defaultBorderRadius,
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: defaultBorderRadius,
        ),
        labelColor: Theme.of(context).textColor,
        unselectedLabelColor: Theme.of(context).subtextColor,
        tabs: tabs,
      ),
    );
  }
}

class CustomPageView extends StatelessWidget {
  const CustomPageView({
    required this.body,
    this.top,
    this.appBar,
    super.key,
  });
  final Widget body;
  final bool? top;
  final AppBar? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: defaultPadding,
            right: defaultPadding,
            top: (top != null && top!) ? defaultPadding : 0,
          ),
          child: body,
        ),
      ),
    );
  }
}

class VerticalSpacer extends StatelessWidget {
  const VerticalSpacer({this.multiple, super.key});
  final double? multiple;
  @override
  Widget build(BuildContext context) {
    return multiple != null
        ? SizedBox(height: defaultSpacing * multiple!)
        : const SizedBox(height: defaultSpacing);
  }
}

class HorizontalSpacer extends StatelessWidget {
  const HorizontalSpacer({this.multiple, super.key});
  final double? multiple;

  @override
  Widget build(BuildContext context) {
    return multiple != null
        ? SizedBox(width: defaultSpacing * multiple!)
        : const SizedBox(width: defaultSpacing);
  }
}
