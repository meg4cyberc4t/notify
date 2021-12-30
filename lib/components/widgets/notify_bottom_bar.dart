import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
        color: Theme.of(context).backgroundColor,
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
          rippleColor: const Color(0xFFE0E0E0),
          hoverColor: const Color(0xFFF5F5F5),
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
