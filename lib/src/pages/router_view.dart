import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notify/src/pages/additional/search/search_view.dart';
import 'package:notify/src/pages/auth/auth_preview.dart';
import 'package:notify/src/pages/calendar/calendar_view.dart';
import 'package:notify/src/pages/home/home_view.dart';
import 'package:notify/src/pages/profile/profile_view.dart';
import 'package:notify/src/settings/sus_service/sus_service.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';

class RouterView extends StatefulWidget {
  const RouterView({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  State<RouterView> createState() => _RouterViewState();
}

class _RouterViewState extends State<RouterView> {
  final PageController _controller = PageController();
  ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return const AuthPreview();
    }

    Widget routerPage = Scaffold(
      body: PageView(
          controller: _controller,
          children: const [
            HomeView(),
            CalendarView(),
            SearchView(),
            ProfileView(),
          ],
          onPageChanged: (final int value) => selectedIndex.value = value),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: selectedIndex,
        builder: (context, value, _) => NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          animationDuration: const Duration(milliseconds: 400),
          selectedIndex: value,
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
      ),
    );

    return SplashScreen.callback(
      name: 'assets/rive/loader.riv',
      onError: (_, __) {},
      until: () async {
        Provider.of<UserNotificationsState>(context, listen: false).load();
        Provider.of<UserState>(context, listen: false).load();
        return;
      },
      backgroundColor: Theme.of(context).backgroundColor,
      height: MediaQuery.of(context).size.width * 0.5,
      endAnimation: 'Animation 1',
      onSuccess: (value) => Navigator.of(context).pushReplacement(
        PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) =>
                FadeTransition(
                  opacity: animation,
                  child: routerPage,
                ),
            transitionDuration: const Duration(milliseconds: 700)),
      ),
    );
  }
}
