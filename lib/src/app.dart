//                         __      __   ______
//                        /  |    /  | /      \
//    _______    ______   _$$ |_   $$/ /$$$$$$  |__    __
//   /       \  /      \ / $$   |  /  |$$ |_ $$//  |  /  |
//   $$$$$$$  |/$$$$$$  |$$$$$$/   $$ |$$   |   $$ |  $$ |
//   $$ |  $$ |$$ |  $$ |  $$ | __ $$ |$$$$/    $$ |  $$ |
//   $$ |  $$ |$$ \__$$ |  $$ |/  |$$ |$$ |     $$ \__$$ |
//   $$ |  $$ |$$    $$/   $$  $$/ $$ |$$ |     $$    $$ |
//   $$/   $$/  $$$$$$/     $$$$/  $$/ $$/       $$$$$$$ |
//                                              /  \__$$ |
//                                              $$    $$/
//                                               $$$$$$/
//
//                                      by Igor Molchanov
//
//  This repository has an introductory nature with the code,
//  using it as an example. It may not start if there are no
//  authorizing elements.

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/components/warnings_view/unknown_error_view.dart';
import 'package:notify/src/pages/additional/color_picker_view.dart';
import 'package:notify/src/pages/additional/folders/create_folder_view.dart';
import 'package:notify/src/pages/additional/folders/create_notification_in_folder_view.dart';
import 'package:notify/src/pages/additional/folders/edit_folder_view.dart';
import 'package:notify/src/pages/additional/folders/folder_participants_view.dart';
import 'package:notify/src/pages/additional/folders/folder_view.dart';
import 'package:notify/src/pages/additional/list_folders_view.dart';
import 'package:notify/src/pages/additional/list_notifications_view.dart';
import 'package:notify/src/pages/additional/list_users_view.dart';
import 'package:notify/src/pages/additional/notification/create_notification_view.dart';
import 'package:notify/src/pages/additional/notification/edit_notification_view.dart';
import 'package:notify/src/pages/additional/notification/notification_participants_view.dart';
import 'package:notify/src/pages/additional/notification/notification_view.dart';
import 'package:notify/src/pages/additional/search/search_view.dart';
import 'package:notify/src/pages/auth/auth_preview.dart';
import 'package:notify/src/pages/auth/sign_up_view.dart';
import 'package:notify/src/pages/calendar/calendar_view.dart';
import 'package:notify/src/pages/home/home_view.dart';
import 'package:notify/src/pages/profile/edit_profile_view.dart';
import 'package:notify/src/pages/profile/profile_view.dart';
import 'package:notify/src/pages/router_view.dart';
import 'package:notify/src/pages/settings/about_view.dart';
import 'package:notify/src/pages/settings/settings_view.dart';
import 'package:notify/src/settings/sus_service/sus_service.dart';
import 'package:notify/src/settings/sus_service/user_folders_state.dart';
import 'package:notify/src/settings/theme_data_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserNotificationsState()),
          ChangeNotifierProvider(create: (context) => UserFoldersState()),
          ChangeNotifierProvider(create: (context) => UserState()),
          ChangeNotifierProvider(
              create: (context) => NotificationViewLocalState()),
          ChangeNotifierProvider(
              create: (context) => NotificationParticipantsLocalState()),
          ChangeNotifierProvider(create: (context) => FolderViewLocalState()),
          ChangeNotifierProvider(
              create: (context) => FolderParticipantsLocalState()),
          ChangeNotifierProvider(create: (context) => ThemeState()),
          ChangeNotifierProvider(
              create: (context) => CustomListViewLocalState())
        ],
        builder: (context, child) {
          return Consumer<ThemeState>(
            builder: (BuildContext context, ThemeState themeNotifier,
                    Widget? child) =>
                MaterialApp(
              restorationScopeId: 'app',
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              onGenerateTitle: (BuildContext context) =>
                  AppLocalizations.of(context)!.appTitle,
              darkTheme: NotifyThemeData.darkThemeData,
              theme: NotifyThemeData.lightThemeData,
              themeMode: themeNotifier.themeMode,
              debugShowCheckedModeBanner: false,
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
                  case ProfileView.routeName:
                    return MaterialPageRoute(
                      settings: routeSettings,
                      builder: (BuildContext context) => ProfileView(
                        id: args?['id'],
                        preTitle: args?['preTitle'],
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
                        onSelect: args['onSelect'],
                      ),
                    );
                  case ListNotificationsView.routeName:
                    return MaterialPageRoute(
                      settings: routeSettings,
                      builder: (BuildContext context) => ListNotificationsView(
                        title: args!['title'],
                        callback: args['callback'],
                        onSelect: args['onSelect'],
                      ),
                    );
                  case ListFoldersView.routeName:
                    return MaterialPageRoute(
                      settings: routeSettings,
                      builder: (BuildContext context) => ListFoldersView(
                        title: args!['title'],
                        callback: args['callback'],
                        onSelect: args['onSelect'],
                      ),
                    );
                  case CreateNotificationView.routeName:
                    return MaterialPageRoute(
                      settings: routeSettings,
                      builder: (BuildContext context) =>
                          const CreateNotificationView(),
                    );
                  case NotificationView.routeName:
                    return MaterialPageRoute<bool>(
                      settings: routeSettings,
                      builder: (BuildContext context) => NotificationView(
                        id: args!['id'],
                        cache: args.containsKey('cache') ? args['cache'] : null,
                      ),
                    );
                  case FolderView.routeName:
                    return MaterialPageRoute(
                      settings: routeSettings,
                      builder: (BuildContext context) => FolderView(
                        id: args!['id'],
                        cache: args.containsKey('cache') ? args['cache'] : null,
                      ),
                    );
                  case EditNotificationView.routeName:
                    return MaterialPageRoute<bool>(
                      settings: routeSettings,
                      builder: (BuildContext context) => EditNotificationView(
                        notification: args!['notification'],
                      ),
                    );
                  case EditFolderView.routeName:
                    return MaterialPageRoute<bool>(
                      settings: routeSettings,
                      builder: (BuildContext context) => EditFolderView(
                        folder: args!['folder'],
                      ),
                    );
                  case FolderParticipantsView.routeName:
                    return MaterialPageRoute<bool>(
                      settings: routeSettings,
                      builder: (BuildContext context) => FolderParticipantsView(
                        folder: args!['folder'],
                      ),
                    );
                  case NotificationParticipantsView.routeName:
                    return MaterialPageRoute<bool>(
                      settings: routeSettings,
                      builder: (BuildContext context) =>
                          NotificationParticipantsView(
                        notification: args!['notification'],
                      ),
                    );
                  case SettingsView.routeName:
                    return MaterialPageRoute(
                      settings: routeSettings,
                      builder: (BuildContext context) => const SettingsView(),
                    );
                  case AboutView.routeName:
                    return MaterialPageRoute(
                      settings: routeSettings,
                      builder: (BuildContext context) => const AboutView(),
                    );
                  case CreateFolderView.routeName:
                    return MaterialPageRoute(
                      settings: routeSettings,
                      builder: (BuildContext context) =>
                          const CreateFolderView(),
                    );
                  case CreateNotificationInFolderView.routeName:
                    return MaterialPageRoute(
                      settings: routeSettings,
                      builder: (BuildContext context) =>
                          CreateNotificationInFolderView(
                        folder: args!['folder'],
                      ),
                    );
                  default:
                    return MaterialPageRoute(
                      settings: routeSettings,
                      builder: (BuildContext context) =>
                          const Scaffold(body: UnknownErrorView()),
                    );
                }
              },
            ),
          );
        });
  }
}
