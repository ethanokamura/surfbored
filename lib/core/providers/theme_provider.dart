// dart packages
import 'package:flutter/material.dart';

// ui libraries
import 'package:rando/config/theme.dart';

/// [ThemeProvider]
/// this class provides all listeners of changes to the theme
/// ie switching from light mode to dark mode
/// notifies the entire app (wraps the main build function)
class ThemeProvider extends ChangeNotifier {
  // initialized
  ThemeData _themeData = darkMode;
  // get current theme
  ThemeData get themeData => _themeData;
  // is current theme dark?
  bool get isDarkMode => _themeData == darkMode;

  // set theme method
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // toggle theme method
  void toggleTheme() {
    themeData = (_themeData == lightMode) ? darkMode : lightMode;
  }
}
