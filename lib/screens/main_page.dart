// ignore_for_file: public_member_api_docs

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notify/configs/notify_parameters.dart';
import 'package:notify/screens/auth_page.dart';
import 'package:notify/screens/home_page.dart';
import 'package:notify/screens/profile_page.dart';
import 'package:notify/screens/search_page.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({final Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _controller = PageController();
  int selectedIndex = 0;

  final List<Widget> tabs = const <Widget>[
    HomePage(key: Key('HomePage')),
    Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: NotifyParameters.circularProgressIndicatorWidth,
        ),
      ),
    ),
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
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: tabs,
        onPageChanged: (final int value) =>
            setState(() => selectedIndex = value),
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
    properties.add(IntProperty('selectedIndex', selectedIndex));
  }
}
