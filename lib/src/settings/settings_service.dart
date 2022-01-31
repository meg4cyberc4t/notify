import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  Future<ThemeMode> themeMode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return ThemeMode.values[preferences.getInt("ThemeMode") ?? 0];
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("ThemeMode", ThemeMode.values.indexOf(theme));
  }
}
