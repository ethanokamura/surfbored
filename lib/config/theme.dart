// dart packages
import 'package:flutter/material.dart';

// ui libraries
import 'package:google_fonts/google_fonts.dart';

// defines custom colors for the app
class CustomTheme {
  // dark mode
  static Color darkAccent = const Color.fromRGBO(97, 175, 239, 1);
  static Color darkBackground = const Color.fromRGBO(29, 32, 37, 1);
  static Color darkSurface = const Color.fromRGBO(40, 44, 52, 1);
  static Color darkPrimary = const Color.fromRGBO(59, 65, 77, 1);
  static Color darkTextColor = const Color.fromRGBO(255, 255, 255, 1);
  static Color darkSubtextColor = const Color.fromRGBO(175, 175, 175, 1);
  static Color darkHintTextColor = const Color.fromRGBO(100, 100, 100, 1);
  static Color inverseDarkTextColor = const Color.fromRGBO(29, 32, 37, 1);

  // light mode
  static Color lightAccent = const Color.fromRGBO(68, 157, 230, 1);
  static Color lightBackground = const Color.fromRGBO(220, 220, 220, 1);
  static Color lightSurface = const Color.fromRGBO(245, 245, 245, 1);
  static Color lightPrimary = const Color.fromRGBO(190, 190, 190, 1);
  static Color lightTextColor = const Color.fromRGBO(10, 10, 10, 1);
  static Color lightSubtextColor = const Color.fromRGBO(64, 64, 64, 1);
  static Color lightHintTextColor = const Color.fromRGBO(100, 100, 100, 1);
  static Color inverseLightTextColor = const Color.fromRGBO(220, 220, 220, 1);
}

// default image config
class ImageConfig {
  static String defaultDarkImage = 'assets/images/dark_mode_face.png';
  static String defaultLightImage = 'assets/images/light_mode_face.png';
}

// show different image based on brightness mode
extension ImageConfigData on ThemeData {
  String get defaultImagePath {
    return brightness == Brightness.dark
        ? ImageConfig.defaultDarkImage
        : ImageConfig.defaultLightImage;
  }
}

// create custom themes that adapt to user brightness mode
extension CustomThemeData on ThemeData {
  /// [accentColor]
  /// Gives the signature look to the app
  Color get accentColor {
    return brightness == Brightness.dark
        ? CustomTheme.darkAccent
        : CustomTheme.lightAccent;
  }

  /// [backgroundColor]
  /// Used for scaffolds
  /// the main background color for the app
  Color get backgroundColor {
    return brightness == Brightness.dark
        ? CustomTheme.darkBackground
        : CustomTheme.lightBackground;
  }

  /// [surfaceColor]
  /// The main color of all widgets on the page
  /// Most common color in the app
  Color get surfaceColor {
    return brightness == Brightness.dark
        ? CustomTheme.darkSurface
        : CustomTheme.lightSurface;
  }

  /// [primaryColor]
  /// Sits on top of surface colored containers / widgets
  /// Secondary surface
  Color get primaryColor {
    return brightness == Brightness.dark
        ? CustomTheme.darkPrimary
        : CustomTheme.lightPrimary;
  }

  /// [textColor]
  /// Default text color for the app
  Color get textColor {
    return brightness == Brightness.dark
        ? CustomTheme.darkTextColor
        : CustomTheme.lightTextColor;
  }

  /// [subtextColor]
  /// Secondary text color. ie used for descriptions
  Color get subtextColor {
    return brightness == Brightness.dark
        ? CustomTheme.darkSubtextColor
        : CustomTheme.lightSubtextColor;
  }

  /// [hintTextColor]
  /// Tertiary color for text. rarely used
  Color get hintTextColor {
    return brightness == Brightness.dark
        ? CustomTheme.darkSubtextColor
        : CustomTheme.lightSubtextColor;
  }

  /// [inverseTextColor]
  /// Used on backgrounds with the accent color
  Color get inverseTextColor {
    return brightness == Brightness.dark
        ? CustomTheme.inverseDarkTextColor
        : CustomTheme.inverseLightTextColor;
  }
}

// Dark Mode
ThemeData darkMode = ThemeData(
  // brightness mode
  brightness: Brightness.dark,

  // default font
  fontFamily: GoogleFonts.rubik().fontFamily,

  // app background color
  scaffoldBackgroundColor: CustomTheme.darkBackground,

  // misc colors
  shadowColor: Colors.black87,

  // custom color scheme
  colorScheme: ColorScheme.dark(
    surface: CustomTheme.darkSurface,
    onSurface: CustomTheme.darkTextColor,
    primary: CustomTheme.darkPrimary,
    onPrimary: CustomTheme.darkTextColor,
  ),

  // default text themes
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      fontSize: 18,
      color: CustomTheme.darkTextColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: CustomTheme.darkTextColor,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      color: CustomTheme.darkTextColor,
    ),
    titleLarge: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w900,
      color: CustomTheme.darkTextColor,
    ),
    titleMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: CustomTheme.darkTextColor,
    ),
    titleSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: CustomTheme.darkTextColor,
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
  scaffoldBackgroundColor: CustomTheme.lightBackground,

  // default shadow color
  shadowColor: Colors.black87,

  // custom color scheme
  colorScheme: ColorScheme.light(
    surface: CustomTheme.lightSurface,
    onSurface: CustomTheme.lightTextColor,
    primary: CustomTheme.lightPrimary,
    onPrimary: CustomTheme.lightTextColor,
  ),

  // default text themes
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      fontSize: 18,
      color: CustomTheme.lightTextColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: CustomTheme.lightTextColor,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      color: CustomTheme.lightTextColor,
    ),
    titleLarge: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w900,
      color: CustomTheme.lightTextColor,
    ),
    titleMedium: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: CustomTheme.lightTextColor,
    ),
    titleSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: CustomTheme.lightTextColor,
    ),
  ),
);
