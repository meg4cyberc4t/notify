import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotifyThemeData {
  static const primary = Color(0xFF8474A1);
  static const primaryVariant = Color(0xFF6EC6CA);

  static const surface = Color(0xFFEFEFEF);

  static const ColorScheme darkColorScheme = ColorScheme(
    primary: primary,
    primaryVariant: primaryVariant,
    secondary: Color(0xff03dac6),
    secondaryVariant: Color(0xff03dac6),
    surface: Color(0xff121212),
    background: Color(0xff121212),
    error: Color(0xffcf6679),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: surface,
    onBackground: Colors.white,
    onError: Colors.black,
    brightness: Brightness.dark,
  );

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: primary,
    primaryVariant: primaryVariant,
    secondary: Color(0xff03dac6),
    secondaryVariant: Color(0xff018786),
    surface: surface,
    background: Colors.white,
    error: Color(0xffb00020),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  static ThemeData getThemeData(ColorScheme colorScheme, TextTheme textTheme) {
    textTheme =
        textTheme.copyWith(button: textTheme.button!.copyWith(fontSize: 24));

    final Color primarySurfaceColor = colorScheme.surface;
    final Color onPrimarySurfaceColor = colorScheme.onSurface;

    return ThemeData(
      brightness: colorScheme.brightness,
      primaryColor: primarySurfaceColor,
      primaryColorBrightness:
          ThemeData.estimateBrightnessForColor(primarySurfaceColor),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      bottomAppBarColor: colorScheme.surface,
      cardColor: colorScheme.surface,
      dividerColor: colorScheme.onSurface.withOpacity(0.12),
      backgroundColor: colorScheme.background,
      dialogBackgroundColor: colorScheme.background,
      errorColor: colorScheme.error,
      indicatorColor: onPrimarySurfaceColor,
      applyElevationOverlayColor: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      listTileTheme: ListTileThemeData(tileColor: colorScheme.background),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearMinHeight: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        height: 60,
      ),
    );
  }

  static ThemeData get lightThemeData {
    ColorScheme colorScheme = lightColorScheme;
    TextTheme textTheme = GoogleFonts.manropeTextTheme().apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface.withOpacity(0.7),
    );
    return getThemeData(colorScheme, textTheme);
  }

  static ThemeData get darkThemeData {
    ColorScheme colorScheme = darkColorScheme;
    TextTheme textTheme = GoogleFonts.manropeTextTheme().apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface.withOpacity(0.7),
    );
    return getThemeData(colorScheme, textTheme);
  }
}
