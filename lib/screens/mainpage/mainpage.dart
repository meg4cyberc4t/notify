import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notify/configs/notify_parameters.dart';
import 'package:notify/screens/auth/authpage.dart';
import 'package:notify/screens/mainpage/homepage.dart';
import 'package:notify/screens/mainpage/profile/profilepage.dart';
import 'package:notify/screens/mainpage/searchpage.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _controller = PageController(initialPage: 0);
  int selectedIndex = 0;

  final tabs = const [
    HomePage(key: Key('HomePage')),
    Scaffold(
        body: Center(
      child: CircularProgressIndicator(
          strokeWidth: NotifyParameters.circularProgressIndicatorWidth),
    )),
    SearchPage(key: Key('ScreenPage')),
    ProfilePage(key: Key('ProfilePage')),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).colorScheme.surface,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light,
    ));

    if (context.watch<User?>() == null) {
      return const AuthPage();
    }
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: tabs,
        onPageChanged: (value) => setState(() => selectedIndex = value),
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        animationDuration: NotifyParameters.duration,
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) => _controller.jumpToPage(value),
        destinations: const [
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
}
