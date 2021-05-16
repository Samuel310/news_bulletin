import 'package:flutter/material.dart';
import 'package:news_bulletin/common/functions/theme_preference.dart';

class ThemeProvider with ChangeNotifier {
  ThemePreference darkThemePreference = ThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}
