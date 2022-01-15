// ignore_for_file: public_member_api_docs

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notify/components/widgets/notify_snack_bar.dart';
import 'package:notify/screens/auth_page.dart';
import 'package:notify/screens/calendar_page.dart';
import 'package:notify/screens/home_page.dart';
import 'package:notify/screens/profile_page.dart';
import 'package:notify/screens/search_page.dart';
import 'package:notify/services/classes/notify_user.dart';
import 'package:notify/services/firebase_service.dart';
import 'package:notify/services/notify_parameters.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({final Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _controller = PageController();
  int selectedIndex = 0;
  bool firstBoot = true;

  final List<Widget> tabs = const <Widget>[
    HomePage(key: Key('HomePage')),
    CalendarPage(key: Key('CalendarPage')),
    SearchPage(key: Key('ScreenPage')),
    ProfilePage(key: Key('ProfilePage')),
  ];

  @override
  Widget build(final BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.surface,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
      ),
    );

    if (context.watch<User?>() == null) {
      return const AuthPage();
    }
    if (firstBoot) {
      Connectivity().checkConnectivity().then((final ConnectivityResult value) {
        if (value == ConnectivityResult.none) {
          ScaffoldMessenger.of(context).showSnackBar(
            notifySnackBar(
              'There is no internet connection. '
              'The latest saved version is used',
              context,
            ),
          );
          debugPrint('No internet!');
        }
      });
      firstBoot = false;
    }
    return Scaffold(
      body: StreamProvider<NotifyUser?>(
        initialData: null,
        create: (final BuildContext _) => FirebaseService.selectUser()
            .snapshots()
            .map((final DocumentSnapshot<NotifyUser> event) => event.data()!),
        child: PageView(
          controller: _controller,
          children: tabs,
          onPageChanged: (final int value) =>
              setState(() => selectedIndex = value),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        animationDuration: NotifyParameters.duration,
        selectedIndex: selectedIndex,
        onDestinationSelected: _controller.jumpToPage,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Person',
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('selectedIndex', selectedIndex))
      ..add(DiagnosticsProperty<bool>('firstBoot', firstBoot));
  }
}
