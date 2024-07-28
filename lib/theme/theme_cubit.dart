import 'package:app_ui/app_ui.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeState { light, dark }

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState.dark) {
    _loadFromPrefs();
  }

  bool get isDarkMode => state == ThemeState.dark;

  Future<void> toggleTheme() async {
    final newState =
        state == ThemeState.light ? ThemeState.dark : ThemeState.light;
    emit(newState);
    await _saveToPrefs(newState);
  }

  ThemeData get themeData {
    return state == ThemeState.light ? lightMode : darkMode;
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    emit(isDark ? ThemeState.dark : ThemeState.light);
  }

  Future<void> _saveToPrefs(ThemeState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', state == ThemeState.dark);
  }
}
