import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify/components/widgets/notify_bottom_bar.dart';
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
    Scaffold(body: Center(child: Text('likes'))),
    SearchPage(key: Key('ScreenPage')),
    ProfilePage(key: Key('ProfilePage')),
  ];

  @override
  Widget build(BuildContext context) {
    if (context.watch<User?>() == null) {
      return const AuthPage();
    }
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: tabs,
        onPageChanged: (value) => setState(() => selectedIndex = value),
      ),
      bottomNavigationBar: NotifyBottomBar(
        selectedIndex: selectedIndex,
        onChange: (value) => _controller.jumpToPage(value),
      ),
    );
  }
}
