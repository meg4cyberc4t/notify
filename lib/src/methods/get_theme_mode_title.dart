import 'package:flutter/material.dart';

String getThemeModeTitle(ThemeMode tm) {
  switch (tm) {
    case ThemeMode.system:
      return 'Системная';
    case ThemeMode.dark:
      return 'Тёмная';
    case ThemeMode.light:
      return 'Светлая';
  }
}
