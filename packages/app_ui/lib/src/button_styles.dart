import 'package:app_ui/src/constants.dart';
import 'package:app_ui/src/theme.dart';
import 'package:flutter/material.dart';

ButtonStyle defaultStyle(BuildContext context, {bool? onSurface}) {
  return ElevatedButton.styleFrom(
    padding: EdgeInsets.zero,
    elevation: 0,
    backgroundColor: onSurface != null && onSurface
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
  );
}

ButtonStyle inversePaddedStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
    padding: const EdgeInsets.all(defaultPadding),
    elevation: 0,
    backgroundColor: Theme.of(context).accentColor,
    shape: const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
  );
}

ButtonStyle inverseStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
    padding: EdgeInsets.zero,
    elevation: 0,
    backgroundColor: Theme.of(context).accentColor,
    shape: const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
  );
}

ButtonStyle noBackgroundStyle() {
  return ElevatedButton.styleFrom(
    padding: EdgeInsets.zero,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}
