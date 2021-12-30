import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotifyThemeData {
  static const Color mainAccentColor1 = Color(0xFF8474A1);
  static const Color mainAccentColor2 = Color(0xFF6EC6CA);
  static const Color mainAccentColor3 = Color(0xFFCCABD8);

  static const Color faultColor = Color(0xFFEF9393);

  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: mainAccentColor1,
    primaryVariant: mainAccentColor1,
    secondary: mainAccentColor2,
    secondaryVariant: mainAccentColor2,
    background: Colors.white,
    onBackground: Colors.black,
    surface: Colors.white,
    // error: faultColor,
    // onError: faultColor,
    // onPrimary: faultColor,
    // onSecondary: Color(0xFF322942),
    // onSurface: Color(0xFF241E30),
  );

  static ThemeData lightThemeData = themeData(
    lightColorScheme,
    _textTheme(lightColorScheme.onBackground),
  );

  // InputDecoration(
  //       contentPadding: const EdgeInsets.all(5),
  //       hintText: widget.hintText,
  //       labelText: widget.labelText,
  //       border: const UnderlineInputBorder(
  //         borderSide: BorderSide(
  //           // color: NotifyTheme.of(context).mainAccentColor1,
  //           width: 1,
  //         ),
  //       ),
  //       focusedBorder: const UnderlineInputBorder(
  //         borderSide: BorderSide(
  //           // color: NotifyTheme.of(context).mainAccentColor1,
  //           width: 2,
  //         ),
  //       ),
  //       errorText: widget.errorText,
  //       errorStyle: Theme.of(context)
  //           .textTheme
  //           .headline6
  //           ?.copyWith(color: Theme.of(context).errorColor),
  //     ),

  static ThemeData themeData2(ColorScheme colorScheme, TextTheme textTheme) {
    return ThemeData.dark();
  }

  static ThemeData themeData(ColorScheme colorScheme, TextTheme textTheme) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.background,
        foregroundColor: colorScheme.onBackground,
        titleTextStyle: textTheme.headline3,
        elevation: 0,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primary,
        selectionColor: colorScheme.primary,
        selectionHandleColor: colorScheme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(5),
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 1,
          ),
        ),
        errorStyle: textTheme.headline6!.copyWith(color: colorScheme.error),
        labelStyle: textTheme.headline5!.copyWith(color: Colors.grey),
      ),
      brightness: colorScheme.brightness,
      primaryColor: colorScheme.primary,
      primaryColorBrightness:
          ThemeData.estimateBrightnessForColor(colorScheme.primary),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      bottomAppBarColor: colorScheme.surface,
      cardColor: colorScheme.onSurface,
      dividerColor: const Color(0xFFEFEFEF),
      backgroundColor: colorScheme.background,
      dialogBackgroundColor: colorScheme.background,
      errorColor: colorScheme.error,
      textTheme: textTheme,
      indicatorColor: colorScheme.onSurface,
      applyElevationOverlayColor: false,
      colorScheme: colorScheme,
    );
  }

// static const _darkFillColor = Colors.white;

  // static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  // static const ColorScheme darkColorScheme = ColorScheme(
  //   primary: mainAccentColor1,
  //   primaryVariant: mainAccentColor1,
  //   secondary: mainAccentColor2,
  //   secondaryVariant: mainAccentColor2,
  //   background: Color(0xFF241E30),
  //   surface: Color(0xFF1F1929),
  //   onBackground: Color(0x0DFFFFFF),
  //   error: _darkFillColor,
  //   onError: _darkFillColor,
  //   onPrimary: _darkFillColor,
  //   onSecondary: _darkFillColor,
  //   onSurface: _darkFillColor,
  //   brightness: Brightness.dark,
  // );

  // static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);

  static TextTheme _textTheme(Color headlineColor) => TextTheme(
        headline1: GoogleFonts.manrope(
          fontSize: 96,
          fontWeight: FontWeight.w300,
          letterSpacing: -1.5,
          color: headlineColor,
        ),
        headline2: GoogleFonts.manrope(
          fontSize: 60,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
          color: headlineColor,
        ),
        headline3: GoogleFonts.manrope(
          fontSize: 48,
          fontWeight: FontWeight.w400,
          color: headlineColor,
        ),
        headline4: GoogleFonts.manrope(
          fontSize: 34,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          color: headlineColor,
        ),
        headline5: GoogleFonts.manrope(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: headlineColor,
        ),
        headline6: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
          color: headlineColor,
        ),
        subtitle1: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.15,
        ),
        subtitle2: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        bodyText1: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        bodyText2: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        button: GoogleFonts.manrope(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
        caption: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),
        overline: GoogleFonts.manrope(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.5,
        ),
      );
}
