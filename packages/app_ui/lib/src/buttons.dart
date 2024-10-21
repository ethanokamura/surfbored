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
class DefaultButton extends StatelessWidget {
  const DefaultButton({
    required this.onTap,
    this.icon,
    this.text,
    this.vertical,
    this.horizontal,
    super.key,
  });

  final IconData? icon;
  final String? text;
  final double? vertical;
  final double? horizontal;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: defaultStyle(context),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal ?? 0,
          vertical: vertical ?? 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) defaultIconStyle(context, icon!),
            if (text != null && icon != null) const SizedBox(width: 10),
            if (text != null)
              ButtonText(
                text: text!,
                inverted: false,
              ),
          ],
        ),
      ),
    );
  }
}

/// Action button for the UI
/// Accent colored background
/// Requires [onTap] function to handle the tap event
/// Optionally takes an [icon] and [text] for UI
/// Optional padding using [horizontal] and [vertical]
class ActionButton extends StatelessWidget {
  const ActionButton({
    required this.onTap,
    this.icon,
    this.text,
    this.vertical,
    this.horizontal,
    super.key,
  });

  final IconData? icon;
  final String? text;
  final double? vertical;
  final double? horizontal;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: accentStyle(context),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal ?? 0,
          vertical: vertical ?? 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) inverseIconStyle(context, icon!),
            if (text != null && icon != null) const SizedBox(width: 10),
            if (text != null)
              ButtonText(
                text: text!,
                inverted: true,
              ),
          ],
        ),
      ),
    );
  }
}

/// Universal Icon button
/// Requires [onTap] function to handle the tap event
/// Requires an [icon] for UI
/// Option UI parameters with [inverted], [background], and [onSurface]
class ActionIconButton extends StatelessWidget {
  const ActionIconButton({
    required this.icon,
    required this.onTap,
    super.key,
    this.inverted,
    this.background,
    this.onSurface,
  });
  final IconData icon;
  final bool? inverted;
  final bool? background;
  final bool? onSurface;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return background != null && background! == false
        ? GestureDetector(
            onTap: onTap,
            child: onSurface != null && onSurface!
                ? surfaceIconStyle(context, icon)
                : inverted != null && inverted!
                    ? accentIconStyle(context, icon)
                    : defaultIconStyle(context, icon),
          )
        : IconButton(
            onPressed: onTap,
            style: background != null && background! == false
                ? noBackgroundStyle()
                : inverted != null && inverted!
                    ? accentStyle(context)
                    : defaultStyle(context, onSurface: onSurface),
            icon: onSurface != null && onSurface!
                ? surfaceIconStyle(context, icon)
                : defaultIconStyle(context, icon),
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
          style: accentStyle(context),
          icon: selectionIconStyle(context, icon),
        ),
        const VerticalSpacer(),
        PrimaryText(text: label),
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
    return isSelected
        ? accentIconStyle(context, AppIcons.checked, size: 22)
        : defaultIconStyle(context, AppIcons.notChecked, size: 22);
  }
}

/// Universal toggle button
/// Used for likes and saves
/// Requires [onTap] function to handle the tap event
/// Optionally add an [icon] or [text] for clarity
/// Option UI parameters with [background] and [onSurface]
class ToggleButton extends StatelessWidget {
  const ToggleButton({
    required this.onSurface,
    required this.onTap,
    super.key,
    this.icon,
    this.text,
    this.background,
  });

  final bool onSurface;
  final bool? background;
  final Icon? icon;
  final String? text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: background != null && background! == false
          ? noBackgroundStyle()
          : defaultStyle(context, onSurface: onSurface),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon!,
          if (text != null && icon != null) const SizedBox(width: 5),
          if (text != null)
            ButtonText(
              text: text!,
              inverted: false,
              fontSize: 14,
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
