import 'package:app_ui/src/constants.dart';
import 'package:app_ui/src/extensions.dart';
import 'package:app_ui/src/icons.dart';
import 'package:app_ui/src/text.dart';
import 'package:app_ui/src/theme.dart';
import 'package:flutter/material.dart';

/// Custom container widget
/// Requires [child] widget to display inside the container
/// Optional padding using [horizontal] and [vertical]
class CustomContainer extends StatelessWidget {
  const CustomContainer({
    required this.child,
    this.horizontal,
    this.vertical,
    super.key,
  });

  final double? horizontal;
  final double? vertical;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.colorScheme.surface,
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

/// TODO(Ethan): remove?
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

/// TODO(Ethan): remove?
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

/// Custom container widget
/// Requires [child] child to display inside the tab
class CustomTabWidget extends StatelessWidget {
  const CustomTabWidget({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tab(child: child);
  }
}

/// Custom container widget
/// Requires [tabs] widget list to display inside the tab bar
class CustomTabBarWidget extends StatelessWidget {
  const CustomTabBarWidget({required this.tabs, super.key});
  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: defaultBorderRadius,
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: context.theme.colorScheme.primary,
          borderRadius: defaultBorderRadius,
        ),
        labelColor: context.theme.textColor,
        unselectedLabelColor: context.theme.subtextColor,
        tabs: tabs,
      ),
    );
  }
}

/// Custom container widget
/// Requires [body] content to display inside the page
/// Optional [appBar] and [top] padding
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

/// Customer vertical spacer with default spacing
class VerticalSpacer extends StatelessWidget {
  const VerticalSpacer({super.key});
  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: defaultSpacing);
  }
}

/// Customer horizontal spacer with default spacing
class HorizontalSpacer extends StatelessWidget {
  const HorizontalSpacer({super.key});
  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: defaultSpacing);
  }
}
