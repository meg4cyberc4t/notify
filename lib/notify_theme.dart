import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotifyColors {
  static const Color mainAccent1 = Color(0xFF8474A1);
  static const Color mainAccent2 = Color(0xFF6EC6CA);
  static const Color mainAccent3 = Color(0xFFCCABD8);

  static const Color allow1 = Color(0xFFCCABD8);
  static const Color allow2 = Color(0xFF6EC6CA);
  static const Color fault = Color(0xFFEF9393);

  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color backgroundCardColor = Color(0xFFEFEFEF);
}

TextTheme buildTextTheme() {
  return GoogleFonts.manropeTextTheme().copyWith(
    button: GoogleFonts.manrope(
      fontSize: 24,
      color: NotifyColors.mainAccent1,
    ),
  );
}

ThemeData buildThemeData() {
  return ThemeData(
    primaryColor: NotifyColors.mainAccent1,
    cardColor: NotifyColors.mainAccent3,
    dialogBackgroundColor: NotifyColors.backgroundCardColor,
    scaffoldBackgroundColor: NotifyColors.backgroundColor,
    backgroundColor: NotifyColors.backgroundColor,
    appBarTheme: const AppBarTheme(centerTitle: true),
    textTheme: buildTextTheme(),
  );
}
