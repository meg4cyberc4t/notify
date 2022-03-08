import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/models/notify_notification_input.dart';
import 'package:notify/src/pages/additional/create_edit_notification_view.dart';
import 'package:notify/src/pages/additional/list_users_view.dart';
import 'package:notify/src/pages/auth/auth_preview.dart';
import 'package:notify/src/pages/auth/sign_up_view.dart';
import 'package:notify/src/pages/brand_book_page.dart';
import 'package:notify/src/pages/calendar/calendar_view.dart';
import 'package:notify/src/pages/additional/color_picker_view.dart';
import 'package:notify/src/pages/home/home_view.dart';
import 'package:notify/src/pages/additional/edit_profile_view.dart';
import 'package:notify/src/pages/profile/my_profile_view.dart';
import 'package:notify/src/pages/profile/profile_view.dart';
import 'package:notify/src/pages/router_view.dart';
import 'package:notify/src/pages/search/search_view.dart';
import 'package:notify/src/settings/api_service/api_service.dart';
import 'package:notify/src/settings/api_service/middleware/api_service_exception.dart';
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
            switch (routeSettings.name) {
              case ColorPickerView.routeName:
                return MaterialPageRoute<Color>(
                  settings: routeSettings,
                  builder: (BuildContext context) => ColorPickerView(
                    title: args!['title'],
                    initialValue: args['color'],
                  ),
                );
              case AuthPreview.routeName:
                return MaterialPageRoute(
                  settings: routeSettings,
                  builder: (BuildContext context) => const AuthPreview(),
                );
              case SignUpView.routeName:
                return MaterialPageRoute(
                  settings: routeSettings,
                  builder: (BuildContext context) => const SignUpView(),
                );
              case RouterView.routeName:
                return MaterialPageRoute(
                  settings: routeSettings,
                  builder: (BuildContext context) => const RouterView(),
                );
              case HomeView.routeName:
                return MaterialPageRoute(
                  settings: routeSettings,
                  builder: (BuildContext context) => const HomeView(),
                );
              case MyProfileView.routeName:
                return MaterialPageRoute(
                  settings: routeSettings,
                  builder: (BuildContext context) => const MyProfileView(),
                );
              case ProfileView.routeName:
                return MaterialPageRoute(
                  settings: routeSettings,
                  builder: (BuildContext context) => ProfileView(
                    id: args!['id'],
                    preTitle: args['preTitle'],
                  ),
                );
              case CalendarView.routeName:
                return MaterialPageRoute(
                  settings: routeSettings,
                  builder: (BuildContext context) => const CalendarView(),
                );
              case SearchView.routeName:
                return MaterialPageRoute(
                  settings: routeSettings,
                  builder: (BuildContext context) => const SearchView(),
                );
              case EditProfileView.routeName:
                return MaterialPageRoute(
                  settings: routeSettings,
                  builder: (BuildContext context) => EditProfileView(
                    user: args!['user'],
                  ),
                );
              case ListUsersView.routeName:
                return MaterialPageRoute(
                  settings: routeSettings,
                  builder: (BuildContext context) => ListUsersView(
                    title: args!['title'],
                    callback: args['callback'],
                  ),
                );
              case __Router.routeName:
                return MaterialPageRoute(
                  settings: routeSettings,
                  builder: (BuildContext context) => const __Router(),
                );
              case CreateEditNotificationView.routeNameCreateNotification:
                return MaterialPageRoute(
                  settings: routeSettings,
                  builder: (BuildContext context) => CreateEditNotificationView(
                    titleView: 'Create notification',
                    onSubmit: (BuildContext context,
                        NotifyNotificationInput ntf, String? _) async {
                      try {
                        await ApiService.notifications.post(
                          title: ntf.title,
                          description: ntf.description,
                          deadline: ntf.deadline,
                          important: ntf.important,
                          repeatMode: ntf.repeatMode,
                        );
                        Navigator.of(context).pop();
                      } on ApiServiceException catch (err) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(err.message),
                        ));
                      }
                    },
                  ),
                );
              case CreateEditNotificationView.routeNameEditNotification:
                return MaterialPageRoute(
                  settings: routeSettings,
                  builder: (BuildContext context) => CreateEditNotificationView(
                    titleView: 'Edit notification',
                    title: args!['title'],
                    description: args['description'],
                    deadline: args['deadline'],
                    important: args['important'],
                    repeatMode: args['repeat_mode'],
                    uuid: args['uuid'],
                    onSubmit: (BuildContext context,
                        NotifyNotificationInput ntf, String? uuid) async {
                      try {
                        await ApiService.notifications.put(
                          uuid: uuid!,
                          title: ntf.title,
                          description: ntf.description,
                          deadline: ntf.deadline,
                          important: ntf.important,
                          repeatMode: ntf.repeatMode,
                        );
                        Navigator.of(context).pop();
                      } on ApiServiceException catch (err) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(err.message),
                        ));
                      }
                    },
                  ),
                );
              default:
                return MaterialPageRoute(
                  settings: routeSettings,
                  builder: (BuildContext context) => const BrandBookPage(),
                );
            }
          },
        );
      },
    );
  }
}

class __Router extends StatelessWidget {
  const __Router({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  Widget build(BuildContext context) =>
      FirebaseAuth.instance.currentUser == null
          ? const AuthPreview()
          : const RouterView();
}
