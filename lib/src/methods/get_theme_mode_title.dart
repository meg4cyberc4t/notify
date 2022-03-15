import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getThemeModeTitle(BuildContext context, ThemeMode tm) {
  switch (tm) {
    case ThemeMode.system:
      return AppLocalizations.of(context)!.system;
    case ThemeMode.dark:
      return AppLocalizations.of(context)!.dark;
    case ThemeMode.light:
      return AppLocalizations.of(context)!.light;
  }
}
