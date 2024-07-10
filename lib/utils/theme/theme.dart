// dart packages
import 'package:flutter/material.dart';

// ui libraries
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static Color darkAccent = Colors.greenAccent.shade400;
  static Color lightAccent = Colors.purple.shade600;
  static Color darkBackground = const Color.fromRGBO(13, 14, 15, 1);
  static Color lightBackground = const Color.fromRGBO(245, 245, 242, 1);
  static Color darkSurface = const Color.fromRGBO(21, 22, 24, 1);
  static Color lightSurface = const Color.fromARGB(255, 221, 221, 214);
  static Color onDarkSurface = Colors.white;
  static Color onLightSurface = Colors.black87;
  static Color darkPrimary = const Color.fromRGBO(21, 22, 24, 1);
  static Color lightPrimary = const Color.fromARGB(255, 221, 221, 214);
  static Color darkTextColor = Colors.white70;
  static Color lightTextColor = Colors.black87;
  static Color darkSubtextColor = Colors.white54;
  static Color lightSubtextColor = Colors.black54;
  static Color darkHintTextColor = Colors.white30;
  static Color lightHintTextColor = Colors.black38;
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

  Color get onSurfaceColor {
    return brightness == Brightness.dark
        ? CustomTheme.darkSurface
        : CustomTheme.lightSurface;
  }

  Color get primaryColor {
    return brightness == Brightness.dark
        ? CustomTheme.onDarkSurface
        : CustomTheme.onLightSurface;
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
          color: CustomTheme.darkTextColor,
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
          color: CustomTheme.darkTextColor,
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
          color: CustomTheme.darkTextColor,
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
        color: CustomTheme.lightTextColor,
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: CustomTheme.lightAccent,
      textStyle: TextStyle(
        color: CustomTheme.lightTextColor,
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
        color: CustomTheme.lightTextColor,
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
);
