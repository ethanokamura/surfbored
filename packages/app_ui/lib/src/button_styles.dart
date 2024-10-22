import 'package:app_ui/src/constants.dart';
import 'package:app_ui/src/extensions.dart';
import 'package:app_ui/src/theme.dart';
import 'package:flutter/material.dart';

ButtonStyle defaultStyle(BuildContext context, {bool? onSurface}) {
  return ElevatedButton.styleFrom(
    padding: EdgeInsets.zero,
    elevation: 0,
    backgroundColor: context.theme.colorScheme.surface,
    shape: const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
  );
}

ButtonStyle accentStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
    padding: EdgeInsets.zero,
    elevation: 0,
    backgroundColor: context.theme.accentColor,
    shape: const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
  );
}

ButtonStyle bottomModalStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
    padding: const EdgeInsets.all(defaultPadding),
    elevation: 0,
    backgroundColor: context.theme.accentColor,
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
