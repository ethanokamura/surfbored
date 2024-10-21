import 'package:app_ui/src/colors.dart';
import 'package:app_ui/src/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// create custom themes that adapt to user brightness mode
extension CustomThemeData on ThemeData {
  /// [defaultImagePath]
  /// Show different images based on brightness mode
  String get defaultImagePath =>
      brightness == Brightness.dark ? defaultDarkImage : defaultLightImage;

  /// [accentColor]
  /// Gives the signature look to the app
  Color get accentColor => CustomColors.accent;

  /// [backgroundColor]
  /// Used for scaffolds
  /// the main background color for the app
  Color get backgroundColor => brightness == Brightness.dark
      ? CustomColors.darkBackground
      : CustomColors.lightBackground;

  /// [surfaceColor]
  /// The main color of all widgets on the page
  /// Most common color in the app
  Color get surfaceColor => brightness == Brightness.dark
      ? CustomColors.darkSurface
      : CustomColors.lightSurface;

  /// [primaryColor]
  /// Sits on top of surface colored containers / widgets
  /// Secondary surface
  Color get primaryColor => brightness == Brightness.dark
      ? CustomColors.darkPrimary
      : CustomColors.lightPrimary;

  /// [textColor]
  /// Default text color for the app
  Color get textColor => brightness == Brightness.dark
      ? CustomColors.darkTextColor
      : CustomColors.lightTextColor;

  /// [subtextColor]
  /// Secondary text color. ie used for descriptions
  Color get subtextColor => brightness == Brightness.dark
      ? CustomColors.darkSubtextColor
      : CustomColors.lightSubtextColor;

  /// [hintTextColor]
  /// Tertiary color for text. rarely used
  Color get hintTextColor => brightness == Brightness.dark
      ? CustomColors.darkSubtextColor
      : CustomColors.lightSubtextColor;

  /// [inverseTextColor]
  /// Used on backgrounds with the accent color
  Color get inverseTextColor => brightness == Brightness.dark
      ? CustomColors.inverseDarkTextColor
      : CustomColors.inverseLightTextColor;
}

// Dark Mode
ThemeData darkMode = ThemeData(
  // brightness mode
  brightness: Brightness.dark,

  // default font
  fontFamily: GoogleFonts.rubik().fontFamily,

  // app background color
  scaffoldBackgroundColor: CustomColors.darkBackground,

  // misc colors
  shadowColor: Colors.black,

  // custom color scheme
  colorScheme: const ColorScheme.dark(
    surface: CustomColors.darkSurface,
    onSurface: CustomColors.darkTextColor,
    primary: CustomColors.darkPrimary,
    onPrimary: CustomColors.darkTextColor,
  ),

  // default text themes
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 18,
      color: CustomColors.darkTextColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: CustomColors.darkTextColor,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      color: CustomColors.darkTextColor,
    ),
    titleLarge: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w900,
      color: CustomColors.darkTextColor,
    ),
    titleMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: CustomColors.darkTextColor,
    ),
    titleSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: CustomColors.darkTextColor,
    ),
  ),
);

// Light Mode
ThemeData lightMode = ThemeData(
  // brightness mode
  brightness: Brightness.light,

  // default font
  fontFamily: GoogleFonts.rubik().fontFamily,

  // app background color
  scaffoldBackgroundColor: CustomColors.lightBackground,

  // default shadow color
  shadowColor: Colors.black,

  // custom color scheme
  colorScheme: const ColorScheme.light(
    surface: CustomColors.lightSurface,
    onSurface: CustomColors.lightTextColor,
    primary: CustomColors.lightPrimary,
    onPrimary: CustomColors.lightTextColor,
  ),

  // default text themes
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 18,
      color: CustomColors.lightTextColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: CustomColors.lightTextColor,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      color: CustomColors.lightTextColor,
    ),
    titleLarge: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w900,
      color: CustomColors.lightTextColor,
    ),
    titleMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: CustomColors.lightTextColor,
    ),
    titleSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: CustomColors.lightTextColor,
    ),
  ),
);
