// dart packages
import 'package:flutter/material.dart';

// ui libraries
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  // dark
  static Color darkBackground = const Color.fromRGBO(29, 32, 37, 1);
  static Color darkSurface = const Color.fromRGBO(40, 44, 52, 1);
  static Color darkPrimary = const Color.fromRGBO(59, 65, 77, 1);
  static Color darkAccent = const Color.fromRGBO(60, 214, 138, 1);
  static Color darkTextColor = Colors.white;
  static Color darkHintTextColor = Colors.white30;
  static Color darkSubtextColor = const Color.fromRGBO(171, 178, 191, 1);
  static Color inverseDarkTextColor = const Color.fromRGBO(29, 32, 37, 1);

  // light
  static Color lightBackground = const Color.fromRGBO(220, 220, 220, 1);
  static Color lightSurface = const Color.fromRGBO(245, 245, 245, 1);
  static Color lightPrimary = const Color.fromRGBO(190, 190, 190, 1);
  static Color lightAccent = const Color.fromRGBO(45, 179, 112, 1);
  static Color lightTextColor = Colors.black87;
  static Color lightSubtextColor = Colors.black54;
  static Color lightHintTextColor = Colors.black38;
  static Color inverseLightTextColor = const Color.fromRGBO(220, 220, 220, 1);
}

extension CustomThemeData on ThemeData {
  Color get accentColor {
    return brightness == Brightness.dark
        ? CustomTheme.darkAccent
        : CustomTheme.lightAccent;
  }

  Color get backgroundColor {
    return brightness == Brightness.dark
        ? CustomTheme.darkBackground
        : CustomTheme.lightBackground;
  }

  Color get surfaceColor {
    return brightness == Brightness.dark
        ? CustomTheme.darkSurface
        : CustomTheme.lightSurface;
  }

  Color get primaryColor {
    return brightness == Brightness.dark
        ? CustomTheme.darkPrimary
        : CustomTheme.lightPrimary;
  }

  Color get textColor {
    return brightness == Brightness.dark
        ? CustomTheme.darkTextColor
        : CustomTheme.lightTextColor;
  }

  Color get subtextColor {
    return brightness == Brightness.dark
        ? CustomTheme.darkSubtextColor
        : CustomTheme.lightSubtextColor;
  }

  Color get hintTextColor {
    return brightness == Brightness.dark
        ? CustomTheme.darkSubtextColor
        : CustomTheme.lightSubtextColor;
  }

  Color get inverseTextColor {
    return brightness == Brightness.dark
        ? CustomTheme.inverseDarkTextColor
        : CustomTheme.inverseLightTextColor;
  }
}

// Dark Mode
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  fontFamily: GoogleFonts.rubik().fontFamily,
  scaffoldBackgroundColor: CustomTheme.darkBackground,
  shadowColor: Colors.black87,
  colorScheme: ColorScheme.dark(
    surface: CustomTheme.darkSurface,
    onSurface: Colors.white,
    primary: CustomTheme.darkPrimary,
    onPrimary: Colors.white,
  ),

  // TEXT
  textTheme: TextTheme(
    // BODY
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
    // TITLE
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

  // BUTTONS
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(CustomTheme.darkAccent),
      textStyle: WidgetStateProperty.all(
        TextStyle(
          color: CustomTheme.darkAccent,
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(CustomTheme.darkAccent),
      textStyle: WidgetStateProperty.all(
        TextStyle(
          color: CustomTheme.darkAccent,
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all(CustomTheme.darkAccent),
      textStyle: WidgetStateProperty.all(
        TextStyle(
          color: CustomTheme.darkAccent,
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
);

// Light Mode
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  fontFamily: GoogleFonts.rubik().fontFamily,
  scaffoldBackgroundColor: CustomTheme.lightBackground,
  shadowColor: Colors.black87,
  colorScheme: ColorScheme.light(
    surface: CustomTheme.lightSurface,
    onSurface: Colors.black87,
    primary: CustomTheme.lightPrimary,
    onPrimary: Colors.black87,
  ),
  // TEXT
  textTheme: TextTheme(
    // BODY
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
    // TITLE
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

  // BUTTONS
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      iconColor: CustomTheme.lightAccent,
      textStyle: TextStyle(
        color: CustomTheme.lightAccent,
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: CustomTheme.lightAccent,
      textStyle: TextStyle(
        color: CustomTheme.lightAccent,
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: CustomTheme.lightAccent,
      side: BorderSide(color: CustomTheme.lightAccent),
      textStyle: TextStyle(
        color: CustomTheme.lightAccent,
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
);
