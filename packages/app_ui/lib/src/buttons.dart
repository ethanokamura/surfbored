import 'package:app_ui/src/button_styles.dart';
import 'package:app_ui/src/extensions.dart';
import 'package:app_ui/src/icons.dart';
import 'package:app_ui/src/text.dart';
import 'package:app_ui/src/theme.dart';
import 'package:app_ui/src/widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Default button for the UI
/// Requires [onTap] function to handle the tap event
/// Optionally takes an [icon] and [text] for UI
/// Optional padding using [horizontal] and [vertical]
class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.onTap,
    this.fontSize,
    this.color,
    this.icon,
    this.text,
    this.vertical,
    this.horizontal,
    super.key,
  });

  final int? color;
  final double? fontSize;
  final IconData? icon;
  final String? text;
  final double? vertical;
  final double? horizontal;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = [
      0,
      1,
      3,
      0,
    ];
    return ElevatedButton(
      onPressed: onTap,
      style: defaultButtonStyle(context, color ?? 0),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal ?? 0,
          vertical: vertical ?? 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              defaultIconStyle(context, icon!, colors[color ?? 0], size: 16),
            if (text != null && icon != null) const SizedBox(width: 5),
            if (text != null)
              CustomText(
                style: buttonText,
                color: colors[color ?? 0],
                fontSize: fontSize,
                text: text!,
              ),
          ],
        ),
      ),
    );
  }
}

/// Icon button for the app bar
/// Requires [onTap] function to handle the tap event
/// Requires an [icon] for UI
class AppBarButton extends StatelessWidget {
  const AppBarButton({
    required this.icon,
    required this.onTap,
    super.key,
  });
  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: appBarIconStyle(context, icon),
    );
  }
}

/// Default button for the UI
/// Requires [onTap] function to handle the tap event
/// Requires [text] for UI
/// Optional padding using [horizontal] and [vertical]
class DefaultTextButton extends StatelessWidget {
  const DefaultTextButton({
    required this.onTap,
    required this.text,
    this.vertical,
    this.horizontal,
    super.key,
  });

  final String text;
  final double? vertical;
  final double? horizontal;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal ?? 0,
          vertical: vertical ?? 0,
        ),
        child: CustomText(
          style: buttonText,
          text: text,
        ),
      ),
    );
  }
}

/// Button for bottom modals
/// Requires [onTap] function to handle the tap event
/// Requires an [icon] and [label] for UI
class BottomModalButton extends StatelessWidget {
  const BottomModalButton({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });
  final IconData icon;
  final String label;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onTap,
          style: defaultButtonStyle(context, 3),
          icon: defaultIconStyle(context, icon, 3, size: 40),
        ),
        const VerticalSpacer(),
        CustomText(text: label, style: primaryText),
      ],
    );
  }
}

/// Check box for board selection
/// Requires [isSelected] to display different icons
class CheckBox extends StatelessWidget {
  const CheckBox({
    required this.isSelected,
    super.key,
  });
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return defaultIconStyle(
      context,
      AppIcons.checked,
      size: 22,
      isSelected ? 4 : 0,
    );
  }
}

/// Universal toggle button
/// Used for likes and saves
/// Requires [onTap] function to handle the tap event
/// Optionally add an [icon] or [text] for clarity
class ToggleButton extends StatelessWidget {
  const ToggleButton({
    required this.onTap,
    super.key,
    this.icon,
    this.text,
  });
  final Icon? icon;
  final String? text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon!,
          if (text != null && icon != null) const SizedBox(width: 5),
          if (text != null)
            CustomText(
              text: text!,
              fontSize: 14,
              style: buttonText,
            ),
        ],
      ),
    );
  }
}

/// Universal link button
/// Requires a [url] to be linked to
class WebLink extends StatelessWidget {
  const WebLink({required this.url, super.key});
  final String url;

  @override
  Widget build(BuildContext context) {
    String parsedURL(String url) {
      var newURL = url;
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasScheme) {
        newURL = 'https://$url';
      }
      return newURL;
    }

    Future<void> launchParsedUrl(String url) async {
      final uri = Uri.parse(parsedURL(url));
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception('Could not launch $url');
      }
    }

    return GestureDetector(
      onTap: () => launchParsedUrl(url),
      child: Text(
        url,
        maxLines: 1,
        style: TextStyle(
          color: context.theme.accentColor,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
