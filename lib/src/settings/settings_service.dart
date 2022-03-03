import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  SettingsService._();
  static SettingsService instance = SettingsService._();

  late final SharedPreferences preferences;

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  String userId() {
    return preferences.getString('selectUserId') ?? '';
  }

  void updateUserId(String id) {
    preferences.setString('selectUserId', id);
  }

  ThemeMode themeMode() {
    return ThemeMode.values[preferences.getInt('ThemeMode') ?? 0];
  }

  void updateThemeMode(ThemeMode theme) {
    preferences.setInt('ThemeMode', ThemeMode.values.indexOf(theme));
  }
}
