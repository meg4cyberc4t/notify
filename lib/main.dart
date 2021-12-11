import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notify/screens/auth/authpage.dart';
import 'package:notify/screens/auth/authpage2.dart';
import 'package:notify/screens/auth/authpage_sign_in.dart';
import 'package:notify/screens/auth/authpage_sign_up.dart';
import 'package:notify/screens/auth/profilepage_edit.dart';
import 'package:notify/screens/mainpage/mainpage.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme mainTextTheme = GoogleFonts.exo2TextTheme();
    return MultiProvider(
      providers: [
        Provider<FirebaseService>(
          create: (_) => FirebaseService(FirebaseAuth.instance),
        ),
        StreamProvider(
          initialData: null,
          create: (context) =>
              context.read<FirebaseService>().currentUser,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF8474A1),
          cardColor: const Color(0xFFCCABD8), // NotificationItem
          dialogBackgroundColor: const Color(0xFFEFEFEF), // FolderItem
          scaffoldBackgroundColor: const Color(0xFFFFFFFF),
          backgroundColor: const Color(0xFFFFFFFF),
          appBarTheme: const AppBarTheme(centerTitle: true),
          textTheme: mainTextTheme
              .apply(displayColor: const Color(0xFF7A7979))
              .copyWith(
                  headline5: mainTextTheme.headline5
                      ?.copyWith(color: const Color(0xFF8474A1)),
                  button: mainTextTheme.button?.copyWith(
                    color: const Color(0xFFFFFFFF),
                    fontSize: 24,
                  )),
        ),
        home: const AuthenticationWrapper(),
        routes: {
          "/AuthPage": (context) => const AuthPage(),
          "/AuthPage2": (context) => const AuthPage2(),
          "/AuthPageSignUp": (context) => const AuthPageSignUp(),
          "/AuthPageSignIn": (context) => const AuthPageSignIn(),
          "/MainPage": (context) => const MainPage(),
          "/ProfilePageEdit": (context) => const ProfilePageEdit(),
          // "/ColorPickerPage": (context) => ColorPickerPage(sdk: sdk),
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      return const MainPage();
    } else {
      return const AuthPage();
    }
  }
}
