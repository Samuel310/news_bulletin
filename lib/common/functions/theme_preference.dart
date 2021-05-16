import 'package:news_bulletin/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference {
  void setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_KEY, value);
  }

  Future<bool> getDartTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_KEY) ?? false;
  }
}
