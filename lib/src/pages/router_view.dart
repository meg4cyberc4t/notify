import 'package:flutter/material.dart';
import 'package:notify/src/pages/calendar/calendar_view.dart';
import 'package:notify/src/pages/home/home_view.dart';
import 'package:notify/src/pages/profile/profile_view.dart';
import 'package:notify/src/pages/search/search_view.dart';

class RouterView extends StatefulWidget {
  const RouterView({Key? key}) : super(key: key);
  static const routeName = '/router_page';

  @override
  State<RouterView> createState() => _RouterViewState();
}

class _RouterViewState extends State<RouterView> {
  final PageController _controller = PageController();
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: const [
          HomeView(),
          CalendarView(),
          SearchView(),
          ProfileView(),
        ],
        onPageChanged: (final int value) =>
            setState(() => selectedIndex = value),
      ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        animationDuration: const Duration(milliseconds: 400),
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
}
