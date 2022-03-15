import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  SettingsService._();
  static SettingsService instance = SettingsService._();

  Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  late final SharedPreferences preferences;

  ThemeMode get themeMode =>
      ThemeMode.values[preferences.getInt('ThemeMode') ?? 0];

  set themeMode(ThemeMode theme) =>
      preferences.setInt('ThemeMode', ThemeMode.values.indexOf(theme));
}
