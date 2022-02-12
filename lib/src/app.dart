import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/pages/auth/auth_preview.dart';
import 'package:notify/src/pages/auth/sign_in_view.dart';
import 'package:notify/src/pages/auth/sign_up_view.dart';
import 'package:notify/src/pages/brand_book_page.dart';
import 'package:notify/src/pages/color_picker_view.dart';
import 'package:notify/src/pages/homepage.dart';
import 'package:notify/src/settings/theme_data_service.dart';

import 'settings/settings_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,
          darkTheme: NotifyThemeData.darkThemeData,
          theme: NotifyThemeData.lightThemeData,
          themeMode: settingsController.themeMode,
          initialRoute: '/',
          onGenerateRoute: (RouteSettings routeSettings) {
            Map<String, dynamic>? args =
                routeSettings.arguments as Map<String, dynamic>?;
            if (routeSettings.name == ColorPickerView.routeName) {
              return MaterialPageRoute<Color>(
                settings: routeSettings,
                builder: (BuildContext context) => ColorPickerView(
                  title: args!['title'],
                  initialValue: args['color'],
                ),
              );
            }
            return MaterialPageRoute(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case AuthPreview.routeName:
                    return const AuthPreview();
                  case SignUpView.routeName:
                    return const SignUpView();
                  case ColorPickerView.routeName:
                    return ColorPickerView(
                      title: args!['title'],
                      initialValue: args['color'],
                    );
                  case HomePage.routeName:
                    return const HomePage();
                  case SignInView.routeName:
                    return const SignInView();
                  case _Router.routeName:
                    return const _Router();
                }
                return const BrandBookPage();
              },
            );
          },
        );
      },
    );
  }
}

class _Router extends StatelessWidget {
  const _Router({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return (FirebaseAuth.instance.currentUser == null)
        ? const AuthPreview()
        : const HomePage();
  }
}
