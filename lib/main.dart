// ignore_for_file: public_member_api_docs

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notify/configs/notify_theme.dart';
import 'package:notify/screens/auth_page.dart';
import 'package:notify/screens/auth_page_sign_in.dart';
import 'package:notify/screens/auth_page_sign_up.dart';
import 'package:notify/screens/create_notification_page.dart';
import 'package:notify/screens/main_page.dart';
import 'package:notify/screens/profile_page_edit.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:notify/services/notifications_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializingSettings();
  LicenseRegistry.addLicense(() async* {
    final String license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(<String>['google_fonts'], license);
  });
  GoogleFonts.config.allowRuntimeFetching = false;
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) => MultiProvider(
        providers: <SingleChildWidget>[
          Provider<FirebaseService>(
            create: (final _) => FirebaseService(),
          ),
          StreamProvider<User?>(
            initialData: null,
            create: (final _) => FirebaseService.auth.authStateChanges(),
          )
        ],
        child: StreamProvider<User?>.value(
          value: FirebaseAuth.instance.authStateChanges(),
          initialData: context.watch<User?>(),
          child: MaterialApp(
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              GlobalMaterialLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            theme: NotifyThemeData.lightThemeData,
            darkTheme: NotifyThemeData.darkThemeData,
            locale: const Locale('ru', 'RU'),
            title: 'Notify',
            initialRoute: '/MainPage',
            routes: <String, WidgetBuilder>{
              '/MainPage': (final _) => const MainPage(),
              '/AuthPage': (final _) => const AuthPage(),
              '/AuthPageSignUp': (final _) => const AuthPageSignUp(),
              '/AuthPageSignIn': (final _) => const AuthPageSignIn(),
              '/ProfilePageEdit': (final _) => const ProfilePageEdit(),
              '/CreateNotificationPage': (final _) =>
                  const CreateNotificationPage(),
            },
          ),
        ),
      );
}
