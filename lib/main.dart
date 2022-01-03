import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notify/screens/auth/authpage.dart';
import 'package:notify/screens/auth/authpage_sign_in.dart';
import 'package:notify/screens/auth/authpage_sign_up.dart';
import 'package:notify/screens/mainpage/mainpage.dart';
import 'package:notify/screens/mainpage/profile/profilepage_edit.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:notify/configs/notify_theme.dart';
import 'package:notify/services/notifications_service.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.initializingSettings();
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  GoogleFonts.config.allowRuntimeFetching = false;
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseService>(
          create: (_) => FirebaseService(FirebaseAuth.instance),
        ),
        StreamProvider<User?>(
          initialData: null,
          create: (context) => context.read<FirebaseService>().currentUser,
        )
      ],
      child: StreamProvider<User?>.value(
        value: FirebaseAuth.instance.authStateChanges(),
        initialData: context.watch<User?>(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          theme: NotifyThemeData.lightThemeData,
          darkTheme: NotifyThemeData.darkThemeData,
          title: 'Notify',
          initialRoute: '/MainPage',
          routes: {
            "/MainPage": (context) => const MainPage(),
            "/AuthPage": (context) => const AuthPage(),
            "/AuthPageSignUp": (context) => const AuthPageSignUp(),
            "/AuthPageSignIn": (context) => const AuthPageSignIn(),
            "/ProfilePageEdit": (context) => const ProfilePageEdit(),
          },
        ),
      ),
    );
  }
}
