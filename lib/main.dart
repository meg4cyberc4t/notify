import 'package:fenestra_sdk_dart/fenestra_sdk_dart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notify/screens/auth/authpage.dart';
import 'package:notify/screens/auth/authpage2.dart';
import 'package:notify/screens/auth/authpage_sign_in.dart';
import 'package:notify/screens/auth/authpage_sign_up.dart';
import 'package:notify/screens/mainpage/mainpage.dart';

void main() async {
  await Hive.initFlutter();
  // Hive.registerAdapter(AuthVariablesAdapter());
  var box = await Hive.openBox('Fenestra');
  runApp(MyApp(storage: box));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.storage}) : super(key: key);
  final Box storage;

  static const serverAddress = "http://185.12.95.163";

  @override
  Widget build(BuildContext context) {
    FenestraSDK sdk = FenestraSDK(
        address: MyApp.serverAddress,
        authVariables: AuthVariables.withSavedCallback(
            authToken: storage.get('auth_token') ?? '',
            refreshToken: storage.get('refresh_token') ?? '',
            savedCallback: (String authToken, String refreshToken) async {
              await storage.put('auth_token', authToken);
              await storage.put('refresh_token', refreshToken);
              print(authToken);
              print('saved\n');
            }));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF8474A1),
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFFFFFFFF),
        textTheme: GoogleFonts.mPlusRounded1cTextTheme().copyWith(
          headline4: GoogleFonts.mPlusRounded1cTextTheme().headline4?.copyWith(
                fontSize: 27,
                overflow: TextOverflow.fade,
              ),
          headline6: GoogleFonts.mPlusRounded1cTextTheme().headline6?.copyWith(
                color: const Color(0xFFCCABD8),
                overflow: TextOverflow.fade,
              ),
          button: GoogleFonts.mPlusRounded1cTextTheme().button?.copyWith(
                color: const Color(0xFFFFFFFF),
                fontSize: 24,
                overflow: TextOverflow.fade,
              ),
        ),
      ),
      home: (storage.get('refresh_token') ?? '').isEmpty
          ? const AuthPage()
          : MainPage(sdk: sdk),
      routes: {
        "/AuthPage": (context) => const AuthPage(),
        "/AuthPage2": (context) => const AuthPage2(),
        "/AuthPageSignUp": (context) => AuthPageSignUp(sdk: sdk),
        "/AuthPageSignIn": (context) => AuthPageSignIn(sdk: sdk),
        "/MainPage": (context) => MainPage(sdk: sdk),
        // "/ColorPickerPage": (context) => ColorPickerPage(sdk: sdk),
      },
    );
  }
}
