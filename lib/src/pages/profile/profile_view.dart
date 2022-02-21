import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);
  static const routeName = 'profile_view';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('ProfileView')),
    );
  }
}
