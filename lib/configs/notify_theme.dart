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
    // ignore: parameter_assignments
    textTheme = textTheme.copyWith(
      bodyText1: textTheme.bodyText1!.copyWith(fontSize: 16),
      bodyText2: textTheme.bodyText2!.copyWith(fontSize: 14),
      headline1: textTheme.headline1!.copyWith(fontSize: 96),
      headline2: textTheme.headline2!.copyWith(fontSize: 60),
      headline3: textTheme.headline3!.copyWith(fontSize: 48),
      headline4: textTheme.headline4!.copyWith(fontSize: 34),
      headline5: textTheme.headline5!.copyWith(fontSize: 24),
      headline6: textTheme.headline6!.copyWith(fontSize: 20),
      caption: textTheme.caption!.copyWith(fontSize: 12),
      overline: textTheme.overline!.copyWith(fontSize: 10),
      subtitle1: textTheme.subtitle1!.copyWith(fontSize: 16),
      subtitle2: textTheme.subtitle2!.copyWith(fontSize: 14),
      button: textTheme.button!.copyWith(fontSize: 24),
    );

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
        height: 50,
      ),
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
