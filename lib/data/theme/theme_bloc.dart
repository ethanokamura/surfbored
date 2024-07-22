import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';
import 'package:rando/config/theme.dart'; // Assuming you have a Theme configuration file

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(themeData: darkMode)) {
    on<ToggleTheme>(_onToggleTheme);
  }

  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) {
    final newThemeData = state.themeData == lightMode ? darkMode : lightMode;
    emit(ThemeState(themeData: newThemeData));
  }
}
