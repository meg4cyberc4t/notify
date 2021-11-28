import 'package:fenestra_sdk_dart/fenestra_sdk_dart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notify/screens/auth/authpage.dart';
import 'package:notify/screens/auth/authpage2.dart';
import 'package:notify/screens/auth/authpage_sign_in.dart';
import 'package:notify/screens/auth/authpage_sign_up.dart';
import 'package:notify/screens/mainpage/mainpage.dart';
import 'package:notify/screens/mainpage/profilepage.dart';

void main() async {
  const serverAddress = "http://185.12.95.163";
  await Hive.initFlutter();
  // Hive.registerAdapter(AuthVariablesAdapter());
  var box = await Hive.openBox('Fenestra');
  runApp(MyApp(storage: box, serverAddress: serverAddress));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.storage, required this.serverAddress})
      : super(key: key);
  final Box storage;
  final String serverAddress;

  @override
  Widget build(BuildContext context) {
    FenestraSDK sdk = FenestraSDK(
      address: serverAddress,
      authVariables: AuthVariables.withSavedCallback(
        authToken: storage.get('auth_token') ?? '',
        refreshToken: storage.get('refresh_token') ?? '',
        savedCallback: (String authToken, String refreshToken) async {
          await storage.put('auth_token', authToken);
          await storage.put('refresh_token', refreshToken);
        },
      ),
    );
    bool isAuth = (storage.get('refresh_token') ?? '').isNotEmpty;
    TextTheme mainTextTheme = GoogleFonts.exo2TextTheme();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF8474A1),
        cardColor: const Color(0xFFCCABD8), // NotificationItem
        dialogBackgroundColor: const Color(0xFFEFEFEF), // FolderItem
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFFFFFFFF),
        appBarTheme: const AppBarTheme(centerTitle: true),
        textTheme: mainTextTheme.copyWith(
            headline5: mainTextTheme.headline5
                ?.copyWith(color: const Color(0xFF8474A1)),
            button: mainTextTheme.button?.copyWith(
              color: const Color(0xFFFFFFFF),
              fontSize: 24,
            )),
      ),
      home: isAuth ? MainPage(sdk: sdk) : const AuthPage(),
      routes: {
        "/AuthPage": (context) => const AuthPage(),
        "/AuthPage2": (context) => const AuthPage2(),
        "/AuthPageSignUp": (context) => AuthPageSignUp(sdk: sdk),
        "/AuthPageSignIn": (context) => AuthPageSignIn(sdk: sdk),
        "/MainPage": (context) => MainPage(sdk: sdk),
        "/ProfilePage": (context) => const ProfilePage(),
        // "/ColorPickerPage": (context) => ColorPickerPage(sdk: sdk),
      },
    );
  }
}
