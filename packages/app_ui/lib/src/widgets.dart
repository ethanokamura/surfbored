import 'package:app_core/app_core.dart';
import 'package:app_ui/src/constants.dart';
import 'package:app_ui/src/extensions.dart';
import 'package:app_ui/src/image.dart';
import 'package:app_ui/src/text.dart';
import 'package:app_ui/src/theme.dart';
import 'package:flutter/material.dart';

/// Custom container widget
/// Requires [child] widget to display inside the container
/// Optional padding using [horizontal] and [vertical]
class CustomContainer extends StatelessWidget {
  const CustomContainer({
    required this.child,
    this.accent,
    this.horizontal,
    this.vertical,
    super.key,
  });

  final bool? accent;
  final double? horizontal;
  final double? vertical;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: accent == null || !accent!
          ? context.theme.colorScheme.surface
          : context.theme.accentColor,
      borderRadius: defaultBorderRadius,
      elevation: defaultElevation,
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

// TODO(Ethan): remove?
// class CustomInputField extends StatelessWidget {
//   const CustomInputField({
//     required this.label,
//     required this.text,
//     required this.onPressed,
//     super.key,
//   });

//   final String label;
//   final String text;
//   final void Function()? onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return CustomContainer(
//       vertical: 0,
//       child: Row(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               child: CustomText(text: text, style: primaryText),
//             ),
//           ),
//           IconButton(
//             onPressed: onPressed,
//             icon: defaultIconStyle(context, AppIcons.edit, 3),
//             padding: EdgeInsets.zero,
//             constraints: const BoxConstraints(),
//             // splashColor: Colors.transparent,
//             // highlightColor: Colors.transparent,
//             tooltip: 'Edit',
//             iconSize: 20,
//           ),
//         ],
//       ),
//     );
//   }
// }

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
class CustomPageView extends StatelessWidget {
  const CustomPageView({
    required this.body,
    this.title,
    this.actions,
    this.centerTitle,
    this.floatingActionButton,
    this.bottomNavigationBar,
    super.key,
  });
  final Widget body;
  final String? title;
  final bool? centerTitle;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final appBar = title != null || actions != null || centerTitle != null;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar
          ? AppBar(
              centerTitle: centerTitle,
              backgroundColor: Colors.transparent,
              title: title != null
                  ? CustomText(
                      text: title!,
                      style: appBarText,
                    )
                  : null,
              actions: actions,
            )
          : null,
      body: ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.theme.backgroundColor,
              Colors.transparent,
              Colors.transparent,
              context.theme.backgroundColor,
            ],
            stops: const [
              0.0,
              0.0,
              0.9,
              1.0,
            ], // 10% purple, 80% transparent, 10% purple
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: Padding(
          padding: const EdgeInsets.only(
            left: defaultPadding,
            right: defaultPadding,
          ),
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class NestedWrapper extends StatelessWidget {
  const NestedWrapper({
    required this.header,
    required this.body,
    super.key,
  });

  final List<Widget> header;
  final List<Widget> body;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverList(
            delegate: SliverChildListDelegate(
              header,
            ),
          ),
        ];
      },
      body: Padding(
        padding: const EdgeInsets.only(bottom: defaultPadding),
        child: Column(
          children: body,
        ),
      ),
    );
  }
}

/// Customer vertical spacer with default spacing
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

/// Customer horizontal spacer with default spacing
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

class UnknownCard extends StatelessWidget {
  const UnknownCard({required this.message, super.key});
  final String message;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Row(
        children: [
          const DefaultImage(
            borderRadius: defaultBorderRadius,
            aspectX: 1,
            aspectY: 1,
            width: 64,
          ),
          const HorizontalSpacer(),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(text: context.l10n.empty, style: primaryText),
                CustomText(text: message, style: secondaryText),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
