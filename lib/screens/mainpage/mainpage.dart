import 'package:bottom_nav_layout/bottom_nav_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:notify/screens/mainpage/homepage.dart';
import 'package:notify/screens/mainpage/profile/profilepage.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomNavLayout(
        lazyLoadPages: true,
        savePageState: true,
        pages: [
          (_) => const HomePage(),
          (_) => const Scaffold(body: Center(child: Text('likes'))),
          (_) => const Scaffold(body: Center(child: Text('search'))),
          (_) => ProfilePage(userUID: context.watch<User>().uid),
        ],
        bottomNavigationBar: (currentIndex, onTap) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                  rippleColor: Colors.grey[300]!,
                  hoverColor: Colors.grey[100]!,
                  gap: 8,
                  tabBorderRadius: 15.0,
                  activeColor: Theme.of(context).primaryColor,
                  iconSize: 24,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                  selectedIndex: currentIndex,
                  onTabChange: (index) => onTap(index)),
            ),
          ),
        ),
      ),
    );
  }
}
