// dart packages
import 'package:flutter/material.dart';

// defines custom colors for the app
abstract class CustomColors {
  // dark mode
  static const Color darkAccent = Color.fromRGBO(97, 175, 239, 1);
  static const Color darkBackground = Color.fromRGBO(29, 32, 37, 1);
  static const Color darkSurface = Color.fromRGBO(40, 44, 52, 1);
  static const Color darkPrimary = Color.fromRGBO(59, 65, 77, 1);
  static const Color darkTextColor = Color.fromRGBO(255, 255, 255, 1);
  static const Color darkSubtextColor = Color.fromRGBO(175, 175, 175, 1);
  static const Color darkHintTextColor = Color.fromRGBO(100, 100, 100, 1);
  static const Color inverseDarkTextColor = Color.fromRGBO(29, 32, 37, 1);

  // light mode
  static const Color lightAccent = Color.fromRGBO(127, 101, 239, 1);
  static const Color lightBackground = Color.fromRGBO(220, 230, 230, 1);
  static const Color lightSurface = Color.fromRGBO(240, 250, 250, 1);
  static const Color lightPrimary = Color.fromRGBO(210, 220, 220, 1);
  static const Color lightTextColor = Color.fromRGBO(10, 10, 10, 1);
  static const Color lightSubtextColor = Color.fromRGBO(64, 64, 64, 1);
  static const Color lightHintTextColor = Color.fromRGBO(100, 100, 100, 1);
  static const Color inverseLightTextColor = Color.fromRGBO(240, 250, 250, 1);
}
