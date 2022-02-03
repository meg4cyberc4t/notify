// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

mixin NotifyThemeData {
  static const Color primaryVariant = Color(0xFF8474A1);
  static const Color primary = Color(0xFF6EC6CA);
  static const Color surface = Color(0xFFEFEFEF);

  static const ColorScheme darkColorScheme = ColorScheme(
    primary: primary,
    primaryVariant: primaryVariant,
    secondary: Color(0xff03dac6),
    secondaryVariant: Color(0xff03dac6),
    surface: Color(0xff121213),
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
    primary: primaryVariant,
    primaryVariant: primary,
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

  static ThemeData getThemeData(
    final ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final Color primarySurfaceColor = colorScheme.surface;
    final Color onPrimarySurfaceColor = colorScheme.onSurface;

    final ButtonStyle buttonStyle = ButtonStyle(
      alignment: Alignment.center,
      animationDuration: const Duration(milliseconds: 500),
      padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );

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
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        height: 50,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        contentPadding: EdgeInsets.all(10),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6200EE)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
      textButtonTheme: TextButtonThemeData(style: buttonStyle),
      outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all<Color>(colorScheme.primary),
        trackColor:
            MaterialStateProperty.all<Color>(Colors.grey.withOpacity(0.5)),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all<Color>(colorScheme.onPrimary),
        fillColor: MaterialStateProperty.all<Color>(colorScheme.primary),
      ),
    );
  }

  static ThemeData get lightThemeData {
    const ColorScheme colorScheme = lightColorScheme;
    final TextTheme textTheme = GoogleFonts.manropeTextTheme().apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface.withOpacity(0.7),
    );
    return getThemeData(colorScheme, textTheme);
  }

  static ThemeData get darkThemeData {
    const ColorScheme colorScheme = darkColorScheme;
    final TextTheme textTheme = GoogleFonts.manropeTextTheme().apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface.withOpacity(0.7),
    );
    return getThemeData(colorScheme, textTheme);
  }
}
