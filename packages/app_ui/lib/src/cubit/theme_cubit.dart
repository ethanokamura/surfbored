import 'package:app_ui/app_ui.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(darkMode); // Default to light mode

  void toggleTheme() {
    emit(state.brightness == Brightness.dark ? lightMode : darkMode);
  }
}
