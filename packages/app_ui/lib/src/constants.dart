import 'package:app_ui/src/strings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// constants
const double defaultPadding = 10;
const double defaultSpacing = 10;
const double defaultRadius = 5;
const BorderRadius defaultBorderRadius =
    BorderRadius.all(Radius.circular(defaultRadius));
const String defaultDarkImage = AppStrings.darkModeIcon;
const String defaultLightImage = AppStrings.lightModeIcon;

class DateFormatter {
  static String formatTimestamp(DateTime dateTime) {
    // Convert Timestamp to DateTime
    // final dateTime = timestamp.toDate();

    // Define the format
    final dateFormat = DateFormat('MMMM dd, yyyy');

    // Format the DateTime to a String
    return dateFormat.format(dateTime);
  }
}
