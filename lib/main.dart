import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notify/screens/auth/authpage.dart';
import 'package:notify/screens/auth/authpage2.dart';
import 'package:notify/screens/auth/authpage_sign_in.dart';
import 'package:notify/screens/auth/authpage_sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF8474A1),
        textTheme: GoogleFonts.montserratTextTheme().copyWith(
          headline4: GoogleFonts.montserratTextTheme().headline4?.copyWith(
                fontSize: 27,
                overflow: TextOverflow.fade,
                // color: const Color(0xFF8474A1),
              ),
          headline6: GoogleFonts.montserratTextTheme().headline6?.copyWith(
                color: const Color(0xFFCCABD8),
                // color: const Color(0xFF8474A1),

                overflow: TextOverflow.fade,
              ),
          button: GoogleFonts.montserratTextTheme().button?.copyWith(
                color: const Color(0xFFFFFFFF),
                fontSize: 24,
                overflow: TextOverflow.fade,
              ),
        ),
      ),
      home: const AuthPage(),
      routes: {
        "/AuthPage": (context) => const AuthPage(),
        "/AuthPage2": (context) => const AuthPage2(),
        "/AuthPageSignUp": (context) => const AuthPageSignUp(),
        "/AuthPageSignIn": (context) => const AuthPageSignIn(),
      },
    );
  }
}
