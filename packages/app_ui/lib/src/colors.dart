// dart packages
import 'package:flutter/material.dart';

// defines custom colors for the app
abstract class CustomColors {
  // dark mode
  static const Color darkAccent = Color(0xff61afef);
  static const Color darkBackground = Color(0xff10141a);
  static const Color darkSurface = Color(0xff1d2025);
  static const Color darkPrimary = Color(0xff282c34);
  static const Color darkTextColor = Color(0xffffffff);
  static const Color darkSubtextColor = Color(0xffabb2bf);
  static const Color darkHintTextColor = Color(0xff8e95a3);
  static const Color inverseDarkTextColor = Color(0xff1d2025);
  static const Color darkGradientStart = Colors.black;
  static const Color darkGradientEnd = Color(0xff1d2025);

  // light mode
  static const Color lightAccent = Color(0xff8875e0);
  static const Color lightBackground = Color(0xfff1f4f8);
  static const Color lightSurface = Color(0xffffffff);
  static const Color lightPrimary = Color(0xffdbe2e7);
  static const Color lightTextColor = Color.fromRGBO(10, 10, 10, 1);
  static const Color lightSubtextColor = Color.fromRGBO(64, 64, 64, 1);
  static const Color lightHintTextColor = Color.fromRGBO(100, 100, 100, 1);
  static const Color inverseLightTextColor = Color.fromRGBO(240, 250, 250, 1);
  static const Color lightGradientStart = Color(0xfff5f8fc);
  static const Color lightGradientEnd = Color(0xfff5f8fc);
}
