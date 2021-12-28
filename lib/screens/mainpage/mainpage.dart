import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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

const tabCount = 4;

class _MainPageState extends State<MainPage> {
  final _controller = PageController(initialPage: 0);
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (context.watch<User?>() == null) {
      return const AuthPage();
    }
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: const [
          HomePage(),
          Scaffold(body: Center(child: Text('likes'))),
          SearchPage(),
          ProfilePage(),
        ],
        onPageChanged: (value) => setState(() => selectedIndex = value),
      ),
      bottomNavigationBar: NotifyBottomBar(
        selectedIndex: selectedIndex,
        onChange: (value) => _controller.jumpToPage(value),
      ),
    );
  }
}

class NotifyBottomBar extends StatelessWidget {
  const NotifyBottomBar({
    Key? key,
    required this.selectedIndex,
    required this.onChange,
  }) : super(key: key);
  final int selectedIndex;
  final ValueChanged<int> onChange;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.1),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        child: GNav(
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
          gap: 8,
          tabBorderRadius: 15.0,
          activeColor: Theme.of(context).primaryColor,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: Colors.grey[100]!,
          color: Colors.black,
          tabs: const [
            GButton(
              icon: CupertinoIcons.home,
              text: 'Home',
            ),
            GButton(
              icon: CupertinoIcons.calendar,
              text: 'Calendar',
            ),
            GButton(
              icon: CupertinoIcons.search,
              text: 'Search',
            ),
            GButton(
              icon: CupertinoIcons.person,
              text: 'Profile',
            ),
          ],
          selectedIndex: selectedIndex,
          onTabChange: onChange,
        ),
      ),
    );
  }
}
