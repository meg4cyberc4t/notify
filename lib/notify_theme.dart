import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

NotifyTheme getNotifyThemeDataFromBrightness(Brightness brightness) {
  switch (brightness) {
    case Brightness.light:
      return NotifyLightTheme();
    case Brightness.dark:
      return NotifyDarkTheme();
  }
}

abstract class NotifyTheme {
  static NotifyTheme of(BuildContext context) => context.watch<NotifyTheme>();

  final Color mainAccentColor1 = const Color(0xFF8474A1);
  final Color mainAccentColor2 = const Color(0xFF6EC6CA);
  final Color mainAccentColor3 = const Color(0xFFCCABD8);

  final Color allowColor1 = const Color(0xFFCCABD8);
  final Color allowColor2 = const Color(0xFF6EC6CA);
  final Color faultColor = const Color(0xFFEF9393);

  Color get backgroundColor;
  Color get backgroundCardColor;

  Brightness get brightness;

  TextTheme mainTextTheme() => GoogleFonts.manropeTextTheme().copyWith(
        button: GoogleFonts.manrope(
          color: mainAccentColor1,
          fontSize: 24,
        ),
      );
}

class NotifyLightTheme extends NotifyTheme {
  @override
  final Color backgroundColor = const Color(0xFFFFFFFF);
  @override
  final Color backgroundCardColor = const Color(0xFFEFEFEF);
  @override
  Brightness brightness = Brightness.light;
}

class NotifyDarkTheme extends NotifyTheme {
  @override
  final Color backgroundColor = const Color(0xFF000000);
  @override
  final Color backgroundCardColor = const Color(0xFF616161);
  @override
  Brightness brightness = Brightness.dark;
}
