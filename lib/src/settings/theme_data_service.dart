import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

mixin NotifyThemeData {
  static ColorScheme darkColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6EC6CA), brightness: Brightness.dark);

  static ColorScheme lightColorScheme =
      ColorScheme.fromSeed(seedColor: const Color(0xFF8474A1));

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
    ColorScheme colorScheme = lightColorScheme;
    final TextTheme textTheme = GoogleFonts.manropeTextTheme().apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface.withOpacity(0.7),
    );
    return getThemeData(colorScheme, textTheme);
  }

  static ThemeData get darkThemeData {
    ColorScheme colorScheme = darkColorScheme;
    final TextTheme textTheme = GoogleFonts.manropeTextTheme().apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface.withOpacity(0.7),
    );
    return getThemeData(colorScheme, textTheme);
  }
}
