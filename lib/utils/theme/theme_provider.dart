// dart packages
import 'package:flutter/material.dart';

// ui libraries
import 'package:rando/utils/theme/theme.dart';

class ThemeProvider extends ChangeNotifier {
  // initialized
  ThemeData _themeData = darkMode;
  // get current theme
  ThemeData get themeData => _themeData;
  // is current theme dark?
  bool get isDarkMode => _themeData == darkMode;

  // set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // toggle theme
  void toggleTheme() {
    themeData = (_themeData == lightMode) ? darkMode : lightMode;
  }
}
