import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeService with ChangeNotifier{
  static const _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeService(){
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final perfs = await SharedPreferences.getInstance();
    final savedTheme = perfs.getString(_themeKey) ?? 'light';

    if(savedTheme == 'dark'){
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  Future<void> _saveThemeToPrefs(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeMode == ThemeMode.dark ? 'dark' : 'light');
  }

  void toggleTheme(){
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    _saveThemeToPrefs(_themeMode);
    notifyListeners();
  } 
}