import 'package:bottom_nav_layout/bottom_nav_layout.dart';
import 'package:fenestra_sdk_dart/fenestra_sdk_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notify/screens/mainpage/homepage.dart';
import 'package:notify/screens/mainpage/profilepage.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key, required this.sdk}) : super(key: key);
  final FenestraSDK sdk;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: Future.sync(() async {
            Box box = Hive.box('Fenestra');
            String refreshToken = await box.get('refresh_token') ?? '';
            var data = await sdk.auth.reloadToken(refreshToken);
            await box.put('refresh_token', data['refresh_token']);
            return data;
          }),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
              return BottomNavLayout(
                  pages: [
                    (_) => const HomePage(),
                    (_) => const Scaffold(body: Center(child: Text('likes'))),
                    (_) => const Scaffold(body: Center(child: Text('search'))),
                    (_) => const ProfilePage(),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 8),
                            child: GNav(
                                rippleColor: Colors.grey[300]!,
                                hoverColor: Colors.grey[100]!,
                                gap: 8,
                                tabBorderRadius: 15.0,
                                activeColor: Theme.of(context).primaryColor,
                                iconSize: 24,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
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
                      ));
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
