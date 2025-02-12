import 'package:app_ui/src/constants.dart';
import 'package:app_ui/src/extensions.dart';
import 'package:app_ui/src/theme.dart';
import 'package:flutter/material.dart';

ButtonStyle defaultButtonStyle(BuildContext context, int color) {
  final colors = [
    context.theme.surfaceColor,
    context.theme.primaryColor,
    context.theme.accentColor,
    // context.theme.secondaryColor,
  ];
  return ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(
      horizontal: defaultPadding,
    ),
    elevation: defaultElevation,
    backgroundColor: colors[color],
    shape: const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
  );
}

ButtonStyle clearButtonStyle() {
  return ElevatedButton.styleFrom(backgroundColor: Colors.transparent);
}
