import 'package:flutter/material.dart';
import 'settings_service.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeNotifier() {
    _themeMode = SettingsService.instance.themeMode;
  }
  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode value) {
    if (value == _themeMode) return;
    _themeMode = value;
    SettingsService.instance.themeMode = value;
    notifyListeners();
  }
}
