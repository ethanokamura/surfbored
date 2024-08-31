// dart packages
import 'package:flutter/material.dart';

// defines custom colors for the app
abstract class CustomColors {
  // dark mode
  static const Color darkAccent = Color(0xff61afef);
  static const Color darkBackground = Color(0xff10141a);
  static const Color darkSurface = Color(0xff151b24);
  static const Color darkPrimary = Color(0xff1d2530);
  static const Color darkTextColor = Color(0xffe1e6f0);
  static const Color darkSubtextColor = Color(0xff969eb0);
  static const Color darkHintTextColor = Color(0xff666e7d);
  static const Color inverseDarkTextColor = Color(0xff151b24);

  // light mode
  static const Color lightAccent = Color(0xff8875e0);
  static const Color lightBackground = Color(0xfff1f4f8);
  static const Color lightSurface = Color(0xffffffff);
  static const Color lightPrimary = Color(0xffe6e9eb);
  static const Color lightTextColor = Color(0xff1a1a1a);
  static const Color lightSubtextColor = Color(0xff1d1d1d);
  static const Color lightHintTextColor = Color(0xff8f8f8f);
  static const Color inverseLightTextColor = Color(0xffffffff);
}
